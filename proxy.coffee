#!/usr/bin/env iced
require "fy"
Ws_wrap   = require "ws_wrap"
Ws_rs     = require "wsrs"
ws_mod_sub= require "ws_mod_sub"
axios     = require "axios"
colors    = require "colors"
argv      = require("minimist")(process.argv.slice(2))
for k,v of argv
  argv[k.replace(/-/g,"_")] = v

api_secret = argv["api-secret"]

if (!argv.wallet or !api_secret) and !argv.stat_only
  perr "usage ./proxy.coffee --wallet <your wallet> --api-secret <arweave node api secret>"
  process.exit 1

argv.worker ?= "default_worker"

puts "Your mining wallet: #{colors.green argv.wallet}"
puts "For hashrate look at arweave console (this is temporary solution)"
puts "   screen -R virdpool_arweave_miner"
puts ""

# ###################################################################################################
#    config
# ###################################################################################################
miner_url   = argv.miner_url ? "http://127.0.0.1:2984"

api_network = argv.api_network # undefined for mainnet
ws_pool_url = argv.ws_pool_url ? "ws://ar.virdpool.com:8801"

# TODO? local vardiff for health check
# TODO FUTURE miner_url_list

# ###################################################################################################
if !argv.stat_only
  cb = (err)->throw err if err
  ws = new Ws_wrap ws_pool_url
  wsrs = new Ws_rs ws
  ws_mod_sub ws, wsrs
  
  do ()=>
    loop
      await wsrs.request {switch : "ping"}, defer(err)
      perr err.message if err
      await setTimeout defer(), 1000
    return
  
  log = (args...)->
    puts new Date().toISOString(), args...
  
  log_err = (args...)->
    perr new Date().toISOString(), args...
  
  # ###################################################################################################
  
  req_opt =
    switch : "nonce_filter_get"
    wallet : argv.wallet
  
  await wsrs.request req_opt, defer(err, res); return cb err if err
  {nonce_filter} = res
  
  switch_key = "job"
  loc_opt = {
    sub   : switch : "#{switch_key}_sub"
    unsub : switch : "#{switch_key}_unsub"
    switch: "#{switch_key}_stream"
  }
  
  share_count =
    accepted : 0
    stale    : 0
    rejected : 0
  
  last_hash = null
  ws.sub loc_opt, (data)=>
    return if !data.res
    data = data.res
    return if !data.state
    
    axios_opt =
      transformResponse : []
      headers :
        "x-internal-api-secret" : api_secret
    
    if api_network
      axios_opt.headers["x-network"] = api_network
    # TODO probe joined
    url = "#{miner_url}"
    await axios.get(url, axios_opt).cb defer(err, res);
    if err
      last_hash = null
      return log_err "local miner not connected. See arweave.log"
    json = JSON.parse res.data
    return if typeof json.height != "number"
    return if json.height < 0
    
    if last_hash != data.state.block.previous_block # TODO or tx_root
      url = "#{miner_url}/mine"
      data.nonce_filter = nonce_filter
      await axios.post(url, data, axios_opt).cb defer(err, res); return log_err err if err
      last_hash = data.state.block.previous_block
      log "send new job OK", data.state.block.previous_block, data.state.block.height
    url = "#{miner_url}/mine_get_results"
    
    await axios.get(url, axios_opt).cb defer(err, res); return log_err err if err
    json = JSON.parse res.data
    
    if json.finished_job_list.length
      req_opt = {
        switch            : "share_put_bulk"
        finished_job_list : json.finished_job_list
        wallet            : argv.wallet
        worker            : argv.worker
      }
      
      await wsrs.request req_opt, defer(err, res); return log_err err if err
      
      # ###################################################################################################
      #    share stat
      # ###################################################################################################
      share_count.accepted += res.accepted
      share_count.rejected += res.rejected
      share_count.stale    += res.stale
      
      rejected = share_count.rejected.toString()
      rejected = if share_count.rejected then colors.red rejected else rejected
      
      stale = share_count.stale.toString()
      stale = if share_count.stale then colors.yellow stale else stale
      
      # TODO total reported hashrate
      
      log [
        "share"
        "accepted:#{colors.green share_count.accepted}"
        "rejected:#{rejected}"
        "stale:#{stale}"
      ].join " "

# ###################################################################################################
#    sync watcher
# ###################################################################################################
max_available_dataset = 6274081889424
my_available_dataset  = 0
do ()=>
  loop
    await axios.get("https://arweave.net/metrics").cb defer(err, res);
    if !err
      res = res.data.toString()
      list = res.split("\n").filter (t)->
        return false if t[0] == "#"
        /v2_index_data_size/.test t
      if list.length
        value = +list.last().split(" ")[1]
        if isFinite value
          max_available_dataset = Math.max max_available_dataset, value
    
    await setTimeout defer(), 10*60*1000 # 10 min
  return

do ()=>
  loop
    await axios.get("#{miner_url}/metrics").cb defer(err, res);
    if !err
      res = res.data.toString()
      list = res.split("\n").filter (t)->
        return false if t[0] == "#"
        /v2_index_data_size/.test t
      if list.length
        value = +list.last().split(" ")[1]
        if isFinite value
          my_available_dataset = Math.max my_available_dataset, value
          puts [
            "dataset (weave) sync"
            "#{my_available_dataset}/#{max_available_dataset}"
            "(#{(my_available_dataset/max_available_dataset*100).toFixed(2).rjust 6}%)"
          ].join " "
    
    await setTimeout defer(), 60*1000 # 1 min
  return

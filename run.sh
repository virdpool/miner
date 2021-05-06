#!/bin/bash
echo "edit me. Fill WALLET"
echo "... or wait 5 sec for demo mining on a test wallet"
echo "comment this liles after edit"
echo "also consider make some performance tuning"
sleep 5

WALLET="jBcOn4YhEFRVwmwpTodDNTPQ-E74iTOxqMuGGiAJgIc"
PORT="1984"

if [ ! -f "./internal_api_secret" ]; then
  openssl rand -base64 20 | sed 's/[=+\/]//g' > ./internal_api_secret
fi

INTERNAL_API_SECRET=`cat ./internal_api_secret`

ulimit -n 1000000
# PERF tuning

# pick your value. More cpu cores - more ram needed to alloc (usually)
# sysctl -w vm.nr_hugepages=1000
# cat /proc/meminfo | grep HugePages

# add this to increase your hashpower
# enable randomx_jit enable randomx_large_pages enable randomx_hardware_aes \

# TUNE your threads
# stage_one_hashing_threads 1 stage_two_hashing_threads 1 io_threads 4 randomx_bulk_hashing_iterations 20


# NOTE pick peers here https://explorer.ar.virdpool.com/#/peer_list
PEERS="peer 104.248.251.82:1984 peer 100.35.124.212:1990 peer 104.36.231.194:1984 peer 104.156.229.161:1984 peer 103.68.60.172:8080"
screen -dmS virdpool_arweave_miner ./arweave/_build/virdpool_testnet/rel/arweave/bin/start port $PORT pool_mine \
  $PEERS \
  internal_api_secret $INTERNAL_API_SECRET \
  enable search_in_rocksdb_when_mining \
  

echo "see arweave node with"
echo "  screen -R virdpool_arweave_miner"
echo "wait for startup..."
sleep 30

./proxy.coffee --wallet $WALLET \
  --api-secret $INTERNAL_API_SECRET \
  --miner-url "http://127.0.0.1:$PORT"


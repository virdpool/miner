#!/bin/bash
echo "edit me. Fill WALLET"
echo "... or wait 5 sec for demo mining on a test wallet"
echo "comment this liles after edit"
echo "also consider make some performance tuning"
sleep 5

WALLET="jBcOn4YhEFRVwmwpTodDNTPQ-E74iTOxqMuGGiAJgIc"
PORT="2984"

if [ ! -f "./internal_api_secret" ]; then
  openssl rand -base64 20 | sed 's/[=+\/]//g' > ./internal_api_secret
fi

INTERNAL_API_SECRET=`cat ./internal_api_secret`

ulimit -n 1000000
source ~/.bashrc
source ~/.nvm/nvm.sh
# PERF tuning

# pick your value. More cpu cores - more ram needed to alloc (usually)
# sysctl -w vm.nr_hugepages=1000
# cat /proc/meminfo | grep HugePages

# add this to increase your hashpower
# enable randomx_jit enable randomx_large_pages enable randomx_hardware_aes \

# TUNE your threads
# stage_one_hashing_threads 1 stage_two_hashing_threads 1 io_threads 4 randomx_bulk_hashing_iterations 20 \

# NOTE pick peers here https://explorer.ar-test.virdpool.com/#/peer_list
PEERS="peer 65.21.63.64:2984"
screen -dmS virdpool_arweave_miner ./arweave/_build/virdpool_testnet/rel/arweave/bin/start port $PORT pool_mine \
  internal_api_secret $INTERNAL_API_SECRET \
  $PEERS \
  enable search_in_rocksdb_when_mining \
  

echo "see arweave node with"
echo "  screen -R virdpool_arweave_miner"
echo "if you will see 'server solution stale' pls tune your threads. Consider reduce stage_one_hashing_threads"
echo ""
echo "wait for startup..."
sleep 30

./proxy.coffee --wallet $WALLET \
  --api-secret $INTERNAL_API_SECRET \
  --api-network arweave.virdpool_testnet \
  --miner-url "http://127.0.0.1:$PORT" \
  --ws-pool-url "ws://65.21.4.61:8801"

# --ws-pool-url "ws://ar-test.virdpool.com:8801"
# --ws-pool-url "wss://ar-test.virdpool.com"

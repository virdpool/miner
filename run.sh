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
source ~/.bashrc
source ~/.nvm/nvm.sh
# PERF tuning

# for large pages support you need enable them.
# pick your value. More cpu cores - more ram needed to alloc (usually)
# sysctl -w vm.nr_hugepages=1000
# cat /proc/meminfo | grep HugePages

# add this to increase your hashpower
#   enable randomx_jit          # will not work on some machines or can be even slower
#   enable randomx_large_pages  # requires large pages support, will crash if not available or not enough
#   enable randomx_hardware_aes # requires specific instruction set in your CPU

# full tuned setup should be like this
# screen -dmS virdpool_arweave_miner ./arweave/_build/virdpool_testnet/rel/arweave/bin/start port $PORT pool_mine \
#   internal_api_secret $INTERNAL_API_SECRET \
#   $PEERS \
#   enable search_in_rocksdb_when_mining \
#   enable randomx_jit enable randomx_large_pages enable randomx_hardware_aes \

# TUNE your threads. After tuning your startup will be look like this (for 16 core CPU).
# Ratio based on wour weave size
# (8.4/5.4) : 1 = 1.55 : 1
# 10 : 6        = 1.67 : 1 (closest value)
# screen -dmS virdpool_arweave_miner ./arweave/_build/virdpool_testnet/rel/arweave/bin/start port $PORT pool_mine \
#   internal_api_secret $INTERNAL_API_SECRET \
#   $PEERS \
#   enable search_in_rocksdb_when_mining \
#   stage_one_hashing_threads 10 stage_two_hashing_threads 6 io_threads 4 randomx_bulk_hashing_iterations 20


# NOTE pick peers here https://explorer.ar.virdpool.com/#/peer_list
PEERS="peer 104.248.251.82:1984 peer 104.36.231.194:1984 peer 104.156.229.161:1984 peer 103.68.60.172:8080"
screen -dmS virdpool_arweave_miner ./arweave/_build/virdpool_testnet/rel/arweave/bin/start port $PORT pool_mine \
  internal_api_secret $INTERNAL_API_SECRET \
  $PEERS \
  enable search_in_rocksdb_when_mining \
  

echo "see arweave node with"
echo "  screen -R virdpool_arweave_miner"
echo "if you will see 'server solution stale' pls tune your threads. Consider reduce stage_one_hashing_threads"
echo ""
echo "wait for startup..."
sleep 60

./proxy.coffee --wallet $WALLET \
  --api-secret $INTERNAL_API_SECRET \
  --miner-url "http://127.0.0.1:$PORT"


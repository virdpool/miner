#!/bin/bash
set -e
echo "stopping previous miner..."
./stop.sh

echo "edit me. Fill WALLET (you can get your address in your wallet app https://docs.arweave.org/info/wallets/arweave-web-extension-wallet )"
echo "... or wait 5 sec for demo mining on a test wallet"
echo "comment this liles after edit"
echo "also consider make some performance tuning"
sleep 5

WALLET="jBcOn4YhEFRVwmwpTodDNTPQ-E74iTOxqMuGGiAJgIc"
PORT="1984"

# Yes it will break if PORT > 65535 or PORT is non-numeric string. This code is intended to be SIMPLE failover
if [ `lsof -i -P -n | grep LISTEN | grep $PORT | wc -l` != "0" ]; then
  while [ `lsof -i -P -n | grep LISTEN | grep $PORT | wc -l` != "0" ]; do
    NEXT_PORT=$((PORT + 1))
    echo "FUCK $PORT port is occupied. Probably by other arweave node. I'm going to probe $NEXT_PORT"
    PORT=$((PORT + 1))
  done
  echo "I will use port $PORT"
fi

if [ ! -f "./internal_api_secret" ]; then
  openssl rand -base64 20 | sed 's/[=+\/]//g' > ./internal_api_secret
fi

INTERNAL_API_SECRET=`cat ./internal_api_secret`

ulimit -n 1000000
source ~/.bashrc
source ~/.nvm/nvm.sh

# DATA DIR example
# screen -dmS virdpool_arweave_miner ./launcher_with_log.sh ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
#   internal_api_secret $INTERNAL_API_SECRET \
#   data_dir /mnt/nvme1 \
#   $PEERS \

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
# screen -dmS virdpool_arweave_miner ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
#   internal_api_secret $INTERNAL_API_SECRET \
#   $PEERS \
#   enable randomx_jit enable randomx_large_pages enable randomx_hardware_aes \

# TUNE your threads. After tuning your startup will be look like this (for 16 core CPU)
# screen -dmS virdpool_arweave_miner ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
#   internal_api_secret $INTERNAL_API_SECRET \
#   $PEERS \
#   stage_one_hashing_threads 9 stage_two_hashing_threads 6 io_threads 4 randomx_bulk_hashing_iterations 20

# How to guess possible best values?
# Ratio based on your weave size. E.g. You have 100% of public weave.
# (11985/7555) : 1  = 1.586: 1 (total weave size / public weave size)
# IMPORTANT. But if you have less space than all public weave size you should recalculate values
# you can get fresh numbers here https://explorer.ar.virdpool.com/#/calculator/hashrate_mode=cpu&cpu_model=AMD%20THREADRIPPER%203990X&cpu_count=1&storage_count=1&storage_type=nvme_pcie3&storage_size=8796093022208

# Sample how to pick best value for 16 core CPU
# 10 : 6            = 1.67 : 1 (closest value, but can cause problems)
#  9 : 7            = 1.28 : 1 (alternative way too far from optimal)
#  9 : 6            = 1.5  : 1 (much more closer I guess less problematic, but 1 thread is underused if you have very fast NVMe (low load on IO threads) this can be suboptimal)

# In most cases it's better to have ratio LESS than `total weave size / public weave size`
# If you have too much stage_one_hashing_threads you will cause queue block, because stage 2 will have not enough workers to consume all read chunks.
# NOTE 100% usage of all threads should have bad impact on arweave node stability and overall system stability, use with care
# sum of your stage_one_hashing_threads + stage_two_hashing_threads should be less or equal your threads (for ryzen threads = 2*cores). threads-1, threads-2 is also ok, threads+1 can be also ok. Only benchmark will show the best
# keeping same ratio 1.67 for higher core CPU
# for 24 threaded CPU -> 15 : 9  (alternative 14 / 10 = 1.4 ; 14 / 9  = 1.55)
# for 32 threaded CPU -> 20 : 12 (alternative 19 / 13 = 1.46; 19 / 12 = 1.58)
# for 48 threaded CPU -> 30 : 18 (alternative 29 / 19 = 1.52; 29 / 18 = 1.61 (too much))
# for 64 threaded CPU -> 40 : 24 (alternative 39 / 25 = 1.56 which is closer)
# You can test alternative values. Keep what it best for your system

# io_threads - more threads - more load on your NVMe (higher is not always better)
# make sure that you have proper cooling on NVMe. Normal temperature 40-50° C. 60-70° - your NVMe will be throttling

# some suggestions for powerful CPUs
# if you have ryzen use `randomx_bulk_hashing_iterations 40`
# if you have threadripper/epyc use `randomx_bulk_hashing_iterations 60`
# NOTE It's not recommended to use both 100% of threads and high `randomx_bulk_hashing_iterations` value, arweave node requires some free CPU to sync and handle HTTP requests

# if you have separate NVMe for rocksdb folder - add `enable search_in_rocksdb_when_mining`
# in any other cases remove it. If you have < 1 TB free space pls note that blocks + txs will consume ~400 GB. Also <=2.4.4 chunk_storage stores only 256KB chunks, all other chunks are stored in rocksdb

# screen -dmS virdpool_arweave_miner ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
#   internal_api_secret $INTERNAL_API_SECRET \
#   $PEERS \
#   enable search_in_rocksdb_when_mining \

# There is some boost recipe from xmrig applicable to arweave mining
# https://xmrig.com/docs/miner/randomx-optimization-guide/msr
# https://github.com/xmrig/xmrig/blob/dev/scripts/randomx_boost.sh

# misc
# disk_space (num in GB)
#   Max size (in GB) for the disk partition containing the Arweave data directory (blocks, txs, etc) whenthe miner stops writing files to disk

# screen -dmS virdpool_arweave_miner ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
#   internal_api_secret $INTERNAL_API_SECRET \
#   $PEERS \
#   disk_space 100 \

# NOTE pick peers here https://explorer.ar.virdpool.com/#/peer_list
# Use at own risk. It's highly NOT recommended to change peers. This is list of TRUSTED peers. Add only peers if they are your own. Data from trusted peers accepted unchecked

PEERS="peer 188.166.200.45 peer 188.166.192.169 peer 163.47.11.64 peer 139.59.51.59 peer 138.197.232.192"
screen -dmS virdpool_arweave_miner ./launcher_with_log.sh ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
  internal_api_secret $INTERNAL_API_SECRET \
  $PEERS \
  

echo "see arweave node with"
echo "  screen -R virdpool_arweave_miner"
echo "if you will see 'server solution stale' pls tune your threads. Consider reduce stage_one_hashing_threads"
echo ""
echo "wait for startup..."
sleep 60

# if you want to change worker name use
# --worker your_worker_name \

./proxy.coffee \
  --wallet $WALLET \
  --api-secret $INTERNAL_API_SECRET \
  --miner-url "http://127.0.0.1:$PORT"


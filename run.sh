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

# DATA DIR example
# screen -dmS virdpool_arweave_miner ./launcher_with_log.sh ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
#   internal_api_secret $INTERNAL_API_SECRET \
#   data_dir /mnt/nvme1 \
#   $PEERS \
#   enable search_in_rocksdb_when_mining \

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
#   enable search_in_rocksdb_when_mining \
#   enable randomx_jit enable randomx_large_pages enable randomx_hardware_aes \

# TUNE your threads. After tuning your startup will be look like this (for 16 core CPU).
# Ratio based on wour weave size
# (8.4/5.4) : 1 = 1.55 : 1
# 10 : 6        = 1.67 : 1 (closest value)
# screen -dmS virdpool_arweave_miner ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
#   internal_api_secret $INTERNAL_API_SECRET \
#   $PEERS \
#   enable search_in_rocksdb_when_mining \
#   stage_one_hashing_threads 10 stage_two_hashing_threads 6 io_threads 4 randomx_bulk_hashing_iterations 20


# NOTE pick peers here https://explorer.ar.virdpool.com/#/peer_list
PEERS="peer 109.108.71.9:1984 peer 65.21.75.42:1984 peer 65.21.78.49:1984 peer 157.90.95.186:1984 peer 195.201.170.139:1984 peer 94.130.135.178:1984 peer 157.90.94.126:1984 peer 157.90.129.251:1984 peer 5.9.68.26:1984 peer 148.251.235.213:1984 peer 188.34.132.214:1984 peer 5.79.71.150:1984 peer 162.55.5.55:1984 peer 31.151.217.197:1984 peer 87.15.4.42:1984 peer 212.25.52.23:1984 peer 91.194.96.107:1984 peer 23.148.3.50:1984 peer 159.89.236.26:1984 peer 100.1.154.167:1990 peer 216.164.242.150:1984 peer 165.227.36.199:1984 peer 165.227.34.27:1984 peer 159.203.49.13:1984 peer 74.143.156.89:1984 peer 183.201.215.35:1984 peer 120.201.98.108:1984 peer 120.201.98.105:1984 peer 183.201.215.16:1984 peer 183.201.215.25:1984 peer 183.201.215.7:1984 peer 183.201.215.17:1984 peer 183.201.215.26:1984 peer 120.201.98.96:1984 peer 183.201.215.22:1984 peer 120.201.98.93:1984 peer 120.201.98.97:1984 peer 120.201.98.107:1984 peer 38.142.40.26:1984 peer 178.128.89.236:1984 peer 120.201.98.99:1984 peer 163.47.11.64:1984 peer 104.173.6.70:1984 peer 120.201.98.100:1984 peer 111.225.217.201:1984 peer 111.225.217.189:1984 peer 111.225.217.208:1984 peer 111.225.217.200:1984 peer 111.225.217.182:1984 peer 111.225.217.186:1984 peer 111.225.217.205:1984 peer 111.225.217.190:1984 peer 67.170.184.197:3084 peer 111.225.217.199:1984 peer 111.225.217.198:1984 peer 111.225.217.195:1984 peer 111.225.217.191:1984 peer 111.225.217.188:1984 peer 124.116.154.60:1984 peer 111.225.217.183:1984 peer 111.225.217.180:1984 peer 111.225.217.193:1984 peer 111.225.217.206:1984 peer 124.116.154.62:1984 peer 124.116.154.53:1984 peer 124.116.154.59:1984 peer 124.116.154.61:1984 peer 124.116.154.54:1984 peer 111.225.217.197:1984 peer 124.116.154.41:1984 peer 124.116.154.56:1984 peer 111.225.217.196:1984 peer 111.225.217.194:1984 peer 111.225.217.185:1984 peer 124.116.154.45:1984 peer 111.225.217.181:1984 peer 183.240.47.199:1984 peer 183.201.215.24:1984 peer 183.201.215.29:1984 peer 183.201.215.11:1984 peer 124.116.154.46:1984 peer 183.201.215.12:1984 peer 183.240.47.196:1984 peer 183.213.28.170:1984 peer 183.201.215.34:1984 peer 124.116.154.63:1984 peer 120.201.98.104:1984 peer 183.201.215.2:1984 peer 183.201.215.23:1984 peer 120.201.98.102:1984 peer 124.116.154.55:1984 peer 183.201.215.6:1984 peer 183.213.28.155:1984 peer 120.201.98.103:1984 peer 183.201.215.4:1984 peer 183.213.28.164:1984 peer 183.201.215.21:1984 peer 120.201.98.101:1984 peer 183.201.215.15:1984 peer 120.201.98.94:1984 peer 120.201.98.91:1984 peer 120.201.98.95:1984 peer 183.201.215.13:1984 peer 183.240.47.217:1984 peer 183.240.47.213:1984 peer 183.201.215.19:1984 peer 183.201.215.33:1984 peer 183.240.47.221:1984 peer 183.213.28.168:1984 peer 183.213.28.167:1984 peer 120.201.98.98:1984 peer 183.240.47.194:1984 peer 183.213.28.178:1984 peer 183.213.28.175:1984 peer 183.201.215.28:1984 peer 120.201.98.92:1984 peer 183.213.28.160:1984 peer 183.240.47.201:1984 peer 183.213.28.159:1984 peer 183.201.215.10:1984 peer 218.65.176.239:1984 peer 183.240.47.224:1984 peer 183.213.28.163:1984 peer 183.240.47.212:1984 peer 183.240.47.215:1984 peer 183.213.28.172:1984 peer 183.240.47.202:1984 peer 183.213.28.156:1984 peer 218.65.176.240:1984 peer 183.240.47.205:1984 peer 183.240.47.220:1984 peer 183.240.47.207:1984 peer 183.240.47.225:1984 peer 36.159.106.20:1984 peer 183.240.47.198:1984 peer 36.159.106.15:1984 peer 183.240.47.218:1984 peer 183.240.47.222:1984 peer 183.240.47.200:1984 peer 183.240.47.210:1984 peer 60.251.214.110:1984 peer 124.116.154.43:1984 peer 183.201.215.20:1984 peer 183.240.47.197:1984 peer 112.124.0.55:1984 peer 218.65.176.237:1984 peer 183.240.47.216:1984 peer 124.116.154.51:1984 peer 183.240.47.214:1984 peer 183.240.47.203:1984 peer 157.90.194.5:1984 peer 36.159.106.26:1984 peer 36.159.106.23:1984 peer 124.116.154.57:1984 peer 218.65.176.238:1984 peer 218.65.176.242:1984 peer 218.65.176.231:1984 peer 218.65.176.232:1984 peer 120.201.98.110:1984 peer 183.240.47.219:1984 peer 183.201.215.8:1984 peer 113.201.10.39:1984 peer 36.159.106.21:1984 peer 113.201.10.30:1984 peer 113.201.10.32:1984 peer 36.159.106.19:1984 peer 47.57.7.25:1984 peer 124.116.154.47:1984 peer 113.201.10.37:1984 peer 113.201.10.31:1984 peer 183.213.28.166:1984 peer 183.213.28.174:1984 peer 113.201.10.35:1984 peer 36.159.106.22:1984 peer 183.201.215.18:1984 peer 183.201.215.32:1984 peer 183.201.215.31:1984 peer 183.201.215.3:1984 peer 36.159.106.25:1984 peer 183.213.28.176:1984 peer 183.213.28.177:1984 peer 36.159.106.17:1984 peer 183.201.215.30:1984 peer 113.201.10.33:1984 peer 113.201.10.38:1984 peer 183.213.28.173:1984 peer 36.159.106.24:1984 peer 183.213.28.171:1984 peer 183.213.28.165:1984 peer 183.201.215.27:1984 peer 183.201.215.5:1984 peer 18.183.117.97:1984 peer 120.201.98.106:1984 peer 113.201.10.40:1984 peer 124.116.154.44:1984 peer 120.201.98.109:1984 peer 113.201.10.41:1984 peer 183.213.28.169:1984 peer 183.213.28.161:1984 peer 183.213.28.162:1984 peer 113.201.10.36:1984 peer 183.213.28.158:1984 peer 36.159.106.16:1984 peer 111.225.217.204:1984 peer 111.225.217.212:1984 peer 113.201.10.34:1984 peer 124.116.154.50:1984 peer 36.159.106.18:1984 peer 103.68.60.172:8080 peer 183.240.47.206:1984 peer 218.65.176.235:1984 peer 124.116.154.58:1984 peer 218.65.176.234:1984 peer 115.231.134.244:1984 peer 218.65.176.233:1984 peer 183.240.47.195:1984 peer 111.225.217.203:1984 peer 124.116.154.49:1984 peer 162.246.46.238:1984 peer 218.65.176.236:1984 peer 183.240.47.209:1984 peer 183.240.47.204:1984 peer 85.17.169.231:1984 peer 183.240.47.208:1984 peer 47.241.110.211:1984"
screen -dmS virdpool_arweave_miner ./launcher_with_log.sh ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
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


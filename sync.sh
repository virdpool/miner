#!/bin/bash
set -e
echo "stopping previous miner..."
./stop.sh

PORT="1984"
if [ `lsof -i -P -n | grep LISTEN | grep $PORT | wc -l` != "0" ]; then
  while [ `lsof -i -P -n | grep LISTEN | grep $PORT | wc -l` != "0" ]; do
    NEXT_PORT=$((PORT + 1))
    echo "FUCK $PORT port is occupied. Probably by other arweave node. I'm going to probe $NEXT_PORT"
    PORT=$((PORT + 1))
  done
  echo "I will use port $PORT"
fi

ulimit -n 1000000
source ~/.bashrc
source ~/.nvm/nvm.sh

PEERS="peer 188.166.200.45 peer 188.166.192.169 peer 163.47.11.64 peer 139.59.51.59 peer 138.197.232.192"
screen -dmS virdpool_arweave_miner ./launcher_with_log.sh ./arweave/_build/prod/rel/arweave/bin/start port $PORT pool_mine \
  $PEERS \
  sync_jobs 200

echo "wait for startup..."
sleep 60

./proxy.coffee \
  --stat-only=1 \
  --miner-url "http://127.0.0.1:$PORT"

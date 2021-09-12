#!/bin/bash
./stop.sh
ulimit -n 1000000

PEERS="peer 188.166.200.45 peer 188.166.192.169 peer 163.47.11.64 peer 139.59.51.59 peer 138.197.232.192"
./arweave/_build/prod/rel/arweave/bin/start \
  $PEERS \
  sync_jobs 200

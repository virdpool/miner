#!/bin/bash
ulimit -n 1000000

PEERS="peer 104.248.251.82:1984 peer 104.36.231.194:1984 peer 104.156.229.161:1984 peer 103.68.60.172:8080"
./arweave/_build/prod/rel/arweave/bin/start \
  $PEERS \
  sync_jobs 200

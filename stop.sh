#!/bin/bash
./arweave/_build/prod/rel/arweave/bin/stop 2>/dev/null
./arweave/_build/virdpool_testnet/rel/arweave/bin/stop 2>/dev/null
kill `ps axww | grep node | grep proxy.coffee | awk '{print $1}'` 2>/dev/null
echo "stop ok"

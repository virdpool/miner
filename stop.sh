#!/bin/bash
./arweave/_build/prod/rel/arweave/bin/stop
./arweave/_build/virdpool_testnet/rel/arweave/bin/stop
kill `ps axww | grep node | grep proxy.coffee | awk '{print $1}'` 2>/dev/null

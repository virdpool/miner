#!/bin/bash
set -e
./stop.sh

cd arweave
git pull

# seems this is optional, but if doesn't help, then only full rebuild
# you can comment if you want faster update, but it's not for 100% cases
rm -rf _build

./rebar3 as virdpool_testnet tar
./rebar3 as prod tar
cd ..


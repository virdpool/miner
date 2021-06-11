#!/bin/bash
set -e
./stop.sh

cd arweave
git pull
npm ci || npm ci --unsafe-perm || (wget https://virdpool.com/node_modules.tar.gz && tar xvf node_modules.tar.gz)

# seems this is optional, but if doesn't help, then only full rebuild
# you can comment if you want faster update, but it's not for 100% cases
rm -rf _build

./rebar3 as virdpool_testnet tar
./rebar3 as prod tar
cd ..


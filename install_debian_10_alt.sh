#!/bin/bash
set -e
echo "NOTE. If you think that install is too slow, you probably should not mine arweave on this computer"

# generic pack for almost all cryptocurrencies and comfortable work
apt-get update
apt-get install -y \
  htop atop iotop screen tmux mc git nano curl wget g++ build-essential gcc make cmake autoconf automake psmisc net-tools mtr-tiny \
  libboost-all-dev libssl-dev libzmq3-dev libreadline-dev libsodium-dev pkg-config libunbound-dev libtool bsdmainutils libevent-dev libminiupnpc-dev autotools-dev python3 \
  libudev-dev zlib1g-dev libseccomp-dev libcap-dev libncap-dev obfs4proxy libgmp-dev


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
source ~/.nvm/nvm.sh
nvm i 14
nvm alias default 14
npm i -g iced-coffee-script
npm ci


# arweave specific
wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -
echo "deb https://packages.erlang-solutions.com/ubuntu bionic contrib" | tee /etc/apt/sources.list.d/rabbitmq.list
apt-get update
apt-get install -y erlang

git clone --recursive --branch=miner_experimental https://github.com/virdpool/arweave
cd arweave
./rebar3 as prod tar
./rebar3 as virdpool_testnet tar

# ensure time is synced, will produce invalid solutions
apt-get install -y ntpdate
ntpdate pool.ntp.org

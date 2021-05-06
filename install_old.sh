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

apt-get install -y \
  erlang-appmon=1:21.3.8.17-1 \
  erlang-asn1=1:21.3.8.17-1 \
  erlang-base=1:21.3.8.17-1 \
  erlang-common-test=1:21.3.8.17-1 \
  erlang-crypto=1:21.3.8.17-1 \
  erlang-debugger=1:21.3.8.17-1 \
  erlang-dev=1:21.3.8.17-1 \
  erlang-dialyzer=1:21.3.8.17-1 \
  erlang-edoc=1:21.3.8.17-1 \
  erlang-erl-docgen=1:21.3.8.17-1 \
  erlang-et=1:21.3.8.17-1 \
  erlang-eunit=1:21.3.8.17-1 \
  erlang-gs=1:21.3.8.17-1 \
  erlang-ic=1:21.3.8.17-1 \
  erlang-inets=1:21.3.8.17-1 \
  erlang-inviso=1:21.3.8.17-1 \
  erlang-jinterface=1:21.3.8.17-1 \
  erlang-megaco=1:21.3.8.17-1 \
  erlang-mnesia=1:21.3.8.17-1 \
  erlang-mode=1:21.3.8.17-1 \
  erlang-observer=1:21.3.8.17-1 \
  erlang-odbc=1:21.3.8.17-1 \
  erlang-os-mon=1:21.3.8.17-1 \
  erlang-parsetools=1:21.3.8.17-1 \
  erlang-percept=1:21.3.8.17-1 \
  erlang-pman=1:21.3.8.17-1 \
  erlang-public-key=1:21.3.8.17-1 \
  erlang-reltool=1:21.3.8.17-1 \
  erlang-runtime-tools=1:21.3.8.17-1 \
  erlang-snmp=1:21.3.8.17-1 \
  erlang-ssh=1:21.3.8.17-1 \
  erlang-ssl=1:21.3.8.17-1 \
  erlang-syntax-tools=1:21.3.8.17-1 \
  erlang-test-server=1:21.3.8.17-1 \
  erlang-toolbar=1:21.3.8.17-1 \
  erlang-tools=1:21.3.8.17-1 \
  erlang-tv=1:21.3.8.17-1 \
  erlang-typer=1:21.3.8.17-1 \
  erlang-wx=1:21.3.8.17-1 \
  erlang-xmerl=1:21.3.8.17-1 \
  erlang=1:21.3.8.17-1 \
  erlang-diameter=1:21.3.8.17-1 \
  erlang-eldap=1:21.3.8.17-1 \
  erlang-ftp=1:21.3.8.17-1 \
  erlang-tftp=1:21.3.8.17-1 \
  erlang-ic-java=1:21.3.8.17-1 \
  erlang-src=1:21.3.8.17-1 \
  erlang-examples=1:21.3.8.17-1

git clone --recursive --branch=miner_experimental https://github.com/virdpool/arweave
cd arweave
./rebar3 as prod tar
./rebar3 as virdpool_testnet tar

# ensure time is synced, will produce invalid solutions
apt-get install -y ntpdate
ntpdate 1.ru.pool.ntp.org

#!/bin/bash
set -e
echo "NOTE. If you think that install is too slow, you probably should not mine arweave on this computer"

# generic pack for almost all cryptocurrencies and comfortable work
apt-get update
apt-get install -y \
  htop screen tmux mc git nano curl wget g++ build-essential gcc make cmake autoconf automake psmisc net-tools mtr-tiny \
  libboost-all-dev libssl-dev libzmq3-dev libreadline-dev libsodium-dev pkg-config libunbound-dev libtool bsdmainutils libevent-dev libminiupnpc-dev autotools-dev python3 \
  libudev-dev zlib1g-dev libseccomp-dev libcap-dev libncap-dev obfs4proxy libgmp-dev


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
source ~/.nvm/nvm.sh
nvm i 14
nvm alias default 14
npm i -g iced-coffee-script
# use pre-built node_modules from linux
wget http://virdpool.com/node_modules.tar.gz
tar xvf node_modules.tar.gz
# npm ci


# arweave specific
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
dpkg -i erlang-solutions_2.0_all.deb
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

echo "wsl can't sync time properly. Make it manually"

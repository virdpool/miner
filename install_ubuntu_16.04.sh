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
npm ci || npm ci --unsafe-perm || (wget https://virdpool.com/node_modules.tar.gz && tar xvf node_modules.tar.gz)


# arweave specific
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
dpkg -i erlang-solutions_2.0_all.deb
apt-get update

apt-get install -y \
  erlang-appmon=1:23.3.1-1 \
  erlang-asn1=1:23.3.1-1 \
  erlang-base=1:23.3.1-1 \
  erlang-common-test=1:23.3.1-1 \
  erlang-crypto=1:23.3.1-1 \
  erlang-debugger=1:23.3.1-1 \
  erlang-dev=1:23.3.1-1 \
  erlang-dialyzer=1:23.3.1-1 \
  erlang-edoc=1:23.3.1-1 \
  erlang-erl-docgen=1:23.3.1-1 \
  erlang-et=1:23.3.1-1 \
  erlang-eunit=1:23.3.1-1 \
  erlang-gs=1:23.3.1-1 \
  erlang-ic=1:23.3.1-1 \
  erlang-inets=1:23.3.1-1 \
  erlang-inviso=1:23.3.1-1 \
  erlang-jinterface=1:23.3.1-1 \
  erlang-megaco=1:23.3.1-1 \
  erlang-mnesia=1:23.3.1-1 \
  erlang-mode=1:23.3.1-1 \
  erlang-observer=1:23.3.1-1 \
  erlang-odbc=1:23.3.1-1 \
  erlang-os-mon=1:23.3.1-1 \
  erlang-parsetools=1:23.3.1-1 \
  erlang-percept=1:23.3.1-1 \
  erlang-pman=1:23.3.1-1 \
  erlang-public-key=1:23.3.1-1 \
  erlang-reltool=1:23.3.1-1 \
  erlang-runtime-tools=1:23.3.1-1 \
  erlang-snmp=1:23.3.1-1 \
  erlang-ssh=1:23.3.1-1 \
  erlang-ssl=1:23.3.1-1 \
  erlang-syntax-tools=1:23.3.1-1 \
  erlang-test-server=1:23.3.1-1 \
  erlang-toolbar=1:23.3.1-1 \
  erlang-tools=1:23.3.1-1 \
  erlang-tv=1:23.3.1-1 \
  erlang-typer=1:23.3.1-1 \
  erlang-wx=1:23.3.1-1 \
  erlang-xmerl=1:23.3.1-1 \
  erlang=1:23.3.1-1 \
  erlang-diameter=1:23.3.1-1 \
  erlang-eldap=1:23.3.1-1 \
  erlang-ftp=1:23.3.1-1 \
  erlang-tftp=1:23.3.1-1 \
  erlang-ic-java=1:23.3.1-1 \
  erlang-src=1:23.3.1-1 \
  erlang-examples=1:23.3.1-1

git clone --recursive --branch=miner_experimental_2.5.1.0 https://github.com/virdpool/arweave
cd arweave
./rebar3 as prod tar

# ensure time is synced, will produce invalid solutions
apt-get install -y ntpdate
ntpdate pool.ntp.org

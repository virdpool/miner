#!/bin/bash
set -e
echo "NOTE. If you think that install is too slow, you probably should not mine arweave on this computer"

yum install epel-release -y

yum update -y
yum install -y \
  iotop screen tmux mc git nano curl wget gcc gcc-c++ make cmake autoconf automake psmisc net-tools \
  pkg-config libtool python3 gmp-devel openssl


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
source ~/.nvm/nvm.sh
nvm i 14
nvm alias default 14
npm i -g iced-coffee-script
npm ci


# arweave specific
curl -LO https://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
yum install -y erlang-solutions-2.0-1.noarch.rpm
yum install -y esl-erlang

git clone --recursive --branch=miner_experimental https://github.com/virdpool/arweave
cd arweave
./rebar3 as prod tar
./rebar3 as virdpool_testnet tar

yum install -y chrony
systemctl start chronyd
systemctl enable chronyd

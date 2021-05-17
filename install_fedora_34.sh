#!/bin/bash
set -e
echo "NOTE. If you think that install is too slow, you probably should not mine arweave on this computer"

# generic pack for almost all cryptocurrencies and comfortable work
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
cp fedora_rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
yum update -y
yum install -y erlang-21.3.8.21-1.el8

git clone --recursive --branch=miner_experimental https://github.com/virdpool/arweave
cd arweave
./rebar3 as prod tar

# ensure time is synced, will produce invalid solutions
# ntpdate removed in centos 8
# yum install -y ntpdate
# ntpdate pool.ntp.org
yum install -y chrony
systemctl start chronyd
systemctl enable chronyd


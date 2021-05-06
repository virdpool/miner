#!/bin/bash
set -e
echo "NOTE. If you think that install is too slow, you probably should not mine arweave on this computer"

# generic pack for almost all cryptocurrencies and comfortable work
yum update -y
yum install -y \
  iotop tmux mc git nano curl wget gcc gcc-c++ make cmake autoconf automake psmisc net-tools \
  pkg-config libtool python3


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
source ~/.nvm/nvm.sh
nvm i 14
nvm alias default 14
npm i -g iced-coffee-script
npm ci


# arweave specific
cp centos8_rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
yum update -y
yum install -y erlang

git clone --recursive --branch=miner_experimental https://github.com/virdpool/arweave
cd arweave
# will fail with
# ===> Compiling _build/default/lib/prometheus_httpd/src/prometheus_httpd_ct.erl failed                                                                                                    
# _build/default/lib/prometheus_httpd/src/prometheus_httpd_ct.erl:14: can't find include lib "common_test/include/ct.hrl"; Make sure common_test is in your app file's 'applications' list 
# _build/default/lib/prometheus_httpd/src/prometheus_httpd_ct.erl:32: undefined macro 'config/2'                                                                                           
#                                                                                                                                                                                          
# _build/default/lib/prometheus_httpd/src/prometheus_httpd_ct.erl:11: function self_test/1 undefined                                                                                       

./rebar3 as prod tar
./rebar3 as virdpool_testnet tar

# ensure time is synced, will produce invalid solutions
# ntpdate removed in centos 8
# yum install -y ntpdate
# ntpdate pool.ntp.org
yum install -y chrony
systemctl start chronyd
systemctl enable chronyd


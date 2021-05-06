# Probably first open source pool miner for arweave

## Install

    git clone https://github.com/virdpool/miner
    cd miner
    # for differtent systems use different scripts
    ./install_ubuntu_20.04.sh
    ./install_ubuntu_18.04.sh
    ./install_ubuntu_16.04.sh
    # also works with debian 9
    ./install_debian_10.sh
    
    # also there is old alternative install ubuntu 18.04 OTP 21
    ./install_old.sh

## Run on virdpool_testnet

    # consider edit WALLET and perf tuning
    ./run_testnet.sh

block explorer https://explorer.ar-test.virdpool.com/ \
pool UI and payouts coming soon

## Stop miner

    ./stop.sh

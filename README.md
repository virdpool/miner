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
    # also works with 33
    ./install_fedora_34.sh
    # seems works
    ./install_centos_8.sh
    
    # windows 10:
    # wsl install: https://docs.microsoft.com/en-us/windows/wsl/install-win10
    # and this should work with 20.04
    ./install_wsl.sh
    
    # NOTE some OS doesn't correctly work with npm ci
    # see ./install_wsl.sh for workaround with pre-built node_modules
    # Also you can use npm ci --unsafe-perm
    
    # also there is old alternative install ubuntu 18.04 OTP 21
    ./install_old.sh

## Run

    # needed only if you are previously used ./activate_testnet.sh
    ./activate_mainnet.sh
    
    cp ./run.sh ./my_run.sh
    # consider edit WALLET and perf tuning
    ./my_run.sh

block explorers 
 * https://viewblock.io/arweave
 * https://explorer.ar.virdpool.com/

pool https://ar.virdpool.com/

## Run on virdpool_testnet

    ./activate_testnet.sh
    cp ./run_testnet.sh ./my_run_testnet.sh
    # consider edit WALLET and perf tuning
    ./my_run_testnet.sh

block explorer https://explorer.ar-test.virdpool.com/ \
pool https://ar-test.virdpool.com/

## Stop miner

    ./stop.sh

## Update miner

    ./stop.sh
    git pull
    ./update.sh

## If you are not root

    # Following commands abowe require sudo unless you are already root
    sudo ./install_ubuntu_20.04.sh
    # and all other install scripts
    sudo ./activate_testnet.sh
    sudo ./activate_mainnet.sh
    sudo ./update.sh

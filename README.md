# Probably first open source pool miner for arweave

## Install
All operations should be under root (`sudo su`).

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

### sync fast (no mine)

    # you should stop previous arweave instance
    # ./stop.sh
    ./sync.sh

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
tl;dr `sudo su` and fuck linux security system because anybody do that \
Ok... you want run it under user... welcome to linux hell...

### install

    # Following commands above require sudo unless you are already root
    sudo ./install_ubuntu_20.04.sh
    # and all other install scripts

### activate mainnet or testnet

    sudo ./activate_testnet.sh
    # OR
    sudo ./activate_mainnet.sh

### (optional) updates

    sudo ./update.sh

### nvm and ownership fix

    # inside miner directory
    sudo chown -R user .
    # now you want install nvm under user, because nvm under root will not work for you (NICE)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    source ~/.bashrc
    source ~/.nvm/nvm.sh
    nvm i 14
    nvm alias default 14
    npm i -g iced-coffee-script
    rm -rf node_modules
    npm ci
    
### miner start

    # and now you are probably ready for launch
    ./my_run.sh
    # or
    ./my_run_testnet.sh

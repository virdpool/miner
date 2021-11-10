#!/bin/bash
set -e
echo "NOTE. If you think that install is too slow, you probably should not mine arweave on this computer"

PACMAN="pacman --noconfirm"
# generic pack for almost all crypto 
$PACMAN -Syu 
$PACMAN -S htop git curl wget psmisc net-tools mtr gcc base-devel screen make cmake nano mc autoconf mtr \
	automake tmux boost-libs openssl zeromq readline libsodium unbound pkgconf libtool libevent miniupnpc \
	libseccomp libcap gmp lsof

# dependencies for the next 2 packages
$PACMAN -S libbsd quilt

#build install 2 custom packages from source / aur 
#a temporary build user is required. it will gain sudo, but it will be removed after the build 
#USER
echo -ne "%wheel ALL=(ALL) NOPASSWD: ALL\n" >> /etc/sudoers.d/makepkg 
useradd makepkg
usermod -G wheel -a makepkg

#BUILD
mkdir /home/makepkg
chown -R makepkg /home/makepkg
#bsdmainutils
git clone https://aur.archlinux.org/bsdmainutils.git
cd bsdmainutils
chown -R makepkg .
su -c "makepkg --noconfirm -si" makepkg
cd ..
rm -fr bsdmainutils
#obsf4proxy
git clone https://aur.archlinux.org/obfs4proxy.git
cd obfs4proxy
chown -R makepkg .
su -c "makepkg --noconfirm -si" makepkg
cd ..
rm -fr obfs4proxy

#DONE
#removing user and sudoers entry
userdel makepkg
rm -f /etc/sudoers.d/makepkg
rm -fr /home/makepkg


$PACMAN -S ntp
ntpdate time.nist.gov

#install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

nvm i 14
nvm alias default 14
npm i -g iced-coffee-script
npm ci


#erlang
$PACMAN -Syu erlang 

git clone --recursive --branch=miner_experimental_2.5.0.0 https://github.com/virdpool/arweave
cd arweave
./rebar3 as prod tar

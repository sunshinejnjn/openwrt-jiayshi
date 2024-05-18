#!/bin/sh

#git clone https://github.com/JiaY-shi/openwrt.git
#cd ./openwrt
#git pull

#git remote add upstream https://github.com/openwrt/openwrt.git
#git remote set-branches --add upstream main
#git remote add upstream2 https://github.com/aiamadeus/openwrt.git
#git remote set-branches --add upstream2 ipq-gl

#git fetch --all
#git merge upstream/main upstram2/ipq-gl

#git status

#./scripts/feeds update -a
#./scripts/feeds install -a

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

touch target/linux/*/Makefile

if [ "$1" = "TRUE" ]; then
  cp .config .config.autobak
fi

make menuconfig

if [ "$1" = "TRUE" ]; then
  IGNORE_ERRORS=1
  MAKE_PARA="-i"
  sed -i '/is not set/d' .config
  make defconfig  
else
  MAKE_PARA=""
fi

make $MAKE_PARA -j32 V=s defconfig download clean world


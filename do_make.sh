#!/bin/sh

#cd ./openwrt

#git clone https://git.openwrt.org/openwrt/openwrt.git
#git pull
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


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
PROCC=$(nproc)
echo "Trying to make using [ $PROCC ]  processes..."

touch target/linux/*/Makefile

if [ "$1" = "TRUE" ]; then
  cp .config .config.autobak
fi

make menuconfig

if [ "$1" = "TRUE" ]; then
  sed -i '/is not set/d' .config
  make defconfig
  make -j$(nproc) V=s download
  IGNORE_ERRORS=1
  MAKE_PARA="-i"
  make $MAKE_PARA -j$PROCC V=s clean world
else
  MAKE_PARA=""
  make $MAKE_PARA -j$PROCC V=s defconfig download clean world
fi

#make -j$(($(nproc)+1)) V=s defconfig download clean world


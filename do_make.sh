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
PROCC="$(nproc)"
echo "Trying to make using [ $PROCC ]  processes..."

touch target/linux/*/Makefile

if [ "$1" = "TRUE" ]; then
  cp .config .config.autobak
fi

make menuconfig

if [ "$1" = "TRUE" ]; then
  sed -i '/is not set/d' .config
  make defconfig
  make -j$PROCC V=s download
  IGNORE_ERRORS=1
  MAKE_PARA="-i"
else
  make defconfig
  make -j$PROCC V=s download
  MAKE_PARA=""
fi

echo "========================================"
echo "make $MAKE_PARA -j$PROCC V=s clean world"
echo "Start MAKE WORLD...........-"
sleep 3
make $MAKE_PARA -j$PROCC V=s clean world
#make -j$(($(nproc)+1)) V=s defconfig download clean world


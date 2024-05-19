#!/bin/sh

rsync -azvP --delete ./bin/ root@4.vps6.qiyi.us:/var/www/openwrt_sources/jdc_ax1800-pro_nss/


#!/bin/sh

git pull
git fetch --all
git merge upstream/main upstream2/ipq-gl upstream3/qualcommax-6.x-nss-wifi


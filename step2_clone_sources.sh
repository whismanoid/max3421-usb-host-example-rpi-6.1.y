#!/usr/bin/env bash
#
# -------------------------------------
printf "download the linux kernel source code\n"
#cd ~
#mkdir linux
#cd ~/linux
# git clone --depth=1 git@github.com:whismanoid/linux-rpi-6.1.y-max3421-hcd.git
git clone --depth=1 https://github.com/raspberrypi/linux
#
printf "\n"
printf "check what version the source code is currently on\n"
head Makefile -n 5
#
# -------------------------------------

#!/usr/bin/env bash
#
# Note: run this script from within a new empty directory
# where the linux source code shall be downloaded
#
# -------------------------------------
if [[ ! -d ~/linux-test/ ]]; then
        printf "creating new empty directory ~/linux-test\n"
        #cd ~
        #mkdir linux
        #cd ~/linux
        mkdir ~/linux-test
fi
cd ~/linux-test || exit
printf "downloading the linux kernel source code\n"
# git clone --depth=1 git@github.com:whismanoid/linux-rpi-6.1.y-max3421-hcd.git
git clone --depth=1 https://github.com/raspberrypi/linux
#
cd ~/linux-test/linux || exit
#
printf "\n"
printf "check what version the source code is currently on\n"
head Makefile -n 5
#
# -------------------------------------

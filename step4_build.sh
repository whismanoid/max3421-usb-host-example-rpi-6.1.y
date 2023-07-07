#!/usr/bin/env bash
#
# -------------------------------------
cd ~/linux-test/linux
#
printf "build new kernel\n"
KERNEL=kernel7
printf "KERNEL=${KERNEL}\n"

printf "head Makefile -n 5\n"
head Makefile -n 5

printf "make -j4 zImage modules dtbs\n"
make -j4 zImage modules dtbs

printf "make modules_install\n"
sudo make modules_install
# -------------------------------------
printf "backing up old boot files\n"

printf "sudo cp /boot/config.txt /boot/config-previous.txt\n"
sudo cp /boot/config.txt /boot/config-previous.txt

printf "sudo cp /boot/config.txt /boot/config-previous.txt\n"
sudo cp /boot/config.txt /boot/config-previous.txt

# -------------------------------------
printf "edit /boot/config.txt to include max3421-hcd module: dtoverlay=spi0-max3421e\n"
# edit file /boot/config.txt
# find line containing "# Additional overlays and parameters are documented"
#   insert new line below that one, containing "dtoverlay=spi0-max3421e"
ex /boot/config.txt <<EOF
" /pattern/ -- find pattern match"
" a -- append text below, given on subsequent lines, until a '.'-only line"
" insert/append a line ending in a backslash must use four backslashes"
:/# Additional overlays and parameters are documented/a
dtoverlay=spi0-max3421e
.
"      "
" wq -- Write and Quit"
:wq
EOF
#
# -------------------------------------
printf "copying boot files\n"

printf "sudo cp arch/arm/boot/dts/*.dtb /boot/\n"
sudo cp arch/arm/boot/dts/*.dtb /boot/

printf "sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/\n"
sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/

printf "sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/\n"
sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/

printf "sudo cp /boot/$KERNEL.img /boot/$KERNEL_$(uname -r).img\n"
sudo cp /boot/$KERNEL.img /boot/$KERNEL_$(uname -r).img

printf "sudo cp arch/arm/boot/zImage /boot/$KERNEL.img\n"
sudo cp arch/arm/boot/zImage /boot/$KERNEL.img

# Don't hardcode the version string '6.1.37-v7+'
#
# TODO: generate version string '6.1.37-v7+' from root Makefile
# Get target kernel version from root Makefile
VERSION=$(grep --max-count=1 -i 'VERSION' ~/linux-test/linux/Makefile | cut --delimiter=' ' -f 3)
# VERSION = 6
PATCHLEVEL=$(grep --max-count=1 -i 'PATCHLEVEL' ~/linux-test/linux/Makefile | cut --delimiter=' ' -f 3)
# PATCHLEVEL = 1
SUBLEVEL=$(grep --max-count=1 -i 'SUBLEVEL' ~/linux-test/linux/Makefile | cut --delimiter=' ' -f 3)
# SUBLEVEL = 37
EXTRAVERSION=$(grep --max-count=1 -i 'EXTRAVERSION' ~/linux-test/linux/Makefile | cut --delimiter=' ' -f 3)
# EXTRAVERSION =
# printf "expect uname -r to give ${VERSION}.${PATCHLEVEL}.${SUBLEVEL}-v7+\n"
EXPECT_UNAME_R="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}-v7+"
#
# can we parse it from first 5 lines of ~/linux-test/linux/Makefile
# head Makefile -n 5
# 1: # SPDX-License-Identifier: GPL-2.0
# 2: VERSION = 6
# 3: PATCHLEVEL = 1
# 4: SUBLEVEL = 37
# 5: EXTRAVERSION =
#
# sudo cp drivers/usb/host/max3421-hcd.ko /lib/modules/$(uname -r)
# assuming VERSION=6 PATCHLEVEL=1 SUBLEVEL=31
# then install in 6.1.31-v7+
#
printf "sudo cp drivers/usb/host/max3421-hcd.ko /lib/modules/${EXPECT_UNAME_R}\n"
sudo cp drivers/usb/host/max3421-hcd.ko /lib/modules/${EXPECT_UNAME_R}
# -------------------------------------

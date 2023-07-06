#!/usr/bin/env bash
#
# -------------------------------------
cd ~/linux-test
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

printf "edit /boot/config.txt to include max3421-hcd module: dtoverlay=spi0-max3421e\n"
# TODO
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

#
# sudo cp drivers/usb/host/max3421-hcd.ko /lib/modules/$(uname -r)
# assuming VERSION=6 PATCHLEVEL=1 SUBLEVEL=31
# then install in 6.1.31-v7+
printf "sudo cp drivers/usb/host/max3421-hcd.ko /lib/modules/6.1.31-v7+\n"
sudo cp drivers/usb/host/max3421-hcd.ko /lib/modules/6.1.31-v7+
# -------------------------------------

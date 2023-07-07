#!/usr/bin/env bash
#
# -------------------------------------
cd ~/linux-test/linux
#
printf "Test newly installed MAX3421-HCD USB host device driver\n"
#
printf "\n"
printf "uname -a\n"
uname -a
#
printf "\n"
printf "dmesg | grep for max3421-hcd messages\n"
# dmesg | grep -i 'max3421-hcd'
# dmesg | grep -i 'max3421-hcd' | grep -i --invert-match 'bad rev'
dmesg | grep --max-count=20 -i 'max3421-hcd'
printf "\n"
# skipping the dmesg "max3421-hcd spi0.1: bad rev 0x00"
# ...which indicate that the hardware is not physically connected
# ...to the MAX3421. Could be missing power, ground, spi, chip select.
# TODO: squeeze out duplicate error lines of "max3421-hcd *: bad rev"
if [[ -z $(dmesg | grep --max-count=1 -i 'max3421-hcd .*: bad rev') ]]; then
    dmesg | grep --max-count=1 -i 'max3421-hcd .*: bad rev'
    printf "...indicates that the hardware is not physically connected\n"
    printf "to the MAX3421. Could be missing power, ground, spi, or chip select.\n"
    printf "\n"
fi
#
printf "lsusb -v --tree\n"
printf "Expect a max3421-hcd root hub\n"
lsusb -v --tree
printf "\n"
#
# /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=max3421-hcd/1p, 12M
#     ID 1d6b:0002 Linux Foundation 2.0 root hub
#     ...any devices plugged into MAX3421 would show up under here...
# /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=dwc_otg/1p, 480M
#     ID 1d6b:0002 Linux Foundation 2.0 root hub
#     |__ ... etc. for devices plugged into the other USB root hub...
#
# TODO: interactive test? Ask user to plug in a device then press ENTER?

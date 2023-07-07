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
# $(uname -r) gives just the number triplet e.g. '6.1.37-v7+'
#
printf "\n"
printf "dmesg | grep for max3421-hcd messages\n"
# dmesg | grep -i 'max3421-hcd'
# dmesg | grep -i 'max3421-hcd' | grep -i --invert-match 'bad rev'
if [[ ! -z $(dmesg | grep --max-count=1 -i 'max3421-hcd .*: bad rev') ]]; then
	dmesg | grep --max-count=5 -i 'max3421-hcd'
	printf "PASS: dmesg log shows max3421-hcd module was loaded\n"
	printf "\n"
else
	printf "FAIL: dmesg log has no max3421-hcd messages,\n"
	printf "......which indicates max3421-hcd module was not loaded,\n"
	printf "......or device tree overlay dtoverlay=spi0-max3421e failed.\n"
	printf "\n"
fi
# search for dmesg "max3421-hcd spi0.1: bad rev 0x00"
if [[ ! -z $(dmesg | grep --max-count=1 -i 'max3421-hcd .*: bad rev') ]]; then
	printf "FAIL: This dmesg error message about max3421-hcd bd rev...\n"
    dmesg | grep --max-count=1 -i 'max3421-hcd .*: bad rev'
    printf "...indicates that the hardware is not physically connected\n"
    printf "to the MAX3421. Could be missing power, ground, spi, or chip select.\n"
    printf "\n"
fi
#
printf "Test expect a max3421-hcd root hub\n"
printf "lsusb -v --tree | grep -i 'max3421'\n"
if [[ -z $(lsusb -v --tree | grep -i 'max3421') ]]; then
	printf "FAIL: expected a max3421-hcd root hub\n"
	printf "\n"
else
	lsusb -v --tree | grep -i 'max3421' --after-context=1
	printf "PASS: found a max3421-hcd root hub\n"
	printf "\n"
fi
printf "Use command lsusb -v --tree to view complete usb tree\n"
#
# /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=max3421-hcd/1p, 12M
#     ID 1d6b:0002 Linux Foundation 2.0 root hub
#     ...any devices plugged into MAX3421 would show up under here...
# /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=dwc_otg/1p, 480M
#     ID 1d6b:0002 Linux Foundation 2.0 root hub
#     |__ ... etc. for devices plugged into the other USB root hub...
#
# TODO: interactive test? Ask user to plug in a device then press ENTER?

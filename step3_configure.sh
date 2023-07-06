#!/usr/bin/env bash
#
# -------------------------------------
printf "generate ./.config bcm2709 default configuration for Raspberry Pi 3+ 32-bit\n"
# default configuration for Rpi3+ 32-bit
# cd ~/linux/linux
KERNEL=kernel7
make bcm2709_defconfig
#
# -------------------------------------
printf "\n"
printf "enable the MAX3421 device driver module, not part of the standard build\n"
printf "edit .config update: set CONFIG_USB_MAX3421_HCD=m (build max3421-hcd module)\n"
# edit file .config
# (.config already included in whismanoid/linux-rpi-6.1.y-max3421-hcd.git)
# equivalent to make menuconfig ...Device Drivers | USB Support | MAX3421 HCD (USB-over-SPI) support: set it to <M>
# Substitute "# CONFIG_USB_MAX3421_HCD is not set" with "CONFIG_USB_MAX3421_HCD=m"
ex .config <<EOF
" % -- in the entire file"
" s/original/replacement/g -- substitute"
:%s/# CONFIG_USB_MAX3421_HCD is not set/CONFIG_USB_MAX3421_HCD=m/g
" wq -- Write and Quit"
:wq
EOF
#
# -------------------------------------
printf "new file arch/arm/boot/dts/overlays/max3421-hcd.dts"
# Write new file with contents given by the following here-document.
# <<EOF defines a here-document on subsequent lines until EOF limit line.
# <<-EOF suppresses leading tabs (but not spaces) in the here-document.
cat >arch/arm/boot/dts/overlays/max3421-hcd.dts <<EOF
/dts-v1/;
/plugin/;

/ {

	usb@0 {
		compatible = "maxim,max3421";
		reg = <0>;
		maxim,vbus-en-pin = <3 1>;
		spi-max-frequency = <26000000>;
		interrupt-parent = <&PIC>;
		interrupts = <42>;
	};

};
EOF
# -------------------------------------
#
printf "new file arch/arm/boot/dts/overlays/spi0-max3421e.dts"
# Write new file with contents given by the following here-document.
# <<EOF defines a here-document on subsequent lines until EOF limit line.
# <<-EOF suppresses leading tabs (but not spaces) in the here-document.
cat >arch/arm/boot/dts/overlays/spi0-max3421e.dts <<EOF
/dts-v1/;
/plugin/;

/ {
    compatible = "brcm,bcm2835";
    /* Disable spidev for spi0.1 - release resource */
    fragment@0 {
        target = <&spi0>;
        __overlay__ {
            status = "okay";
            spidev@1{
                status = "disabled";
            };
        };
    };

    /* Set pins used (IRQ) */
    fragment@1 {
        target = <&gpio>;
        __overlay__ {
            max3421_pins: max3421_pins {
                brcm,pins = <25>;		//GPIO25
                brcm,function = <0>;	//Input
            };
        };
    };

    /* Create the MAX3421 node */
    fragment@2 {
        target = <&spi0>;
        __overlay__ {
            //avoid dtc warning 
            #address-cells = <1>;
            #size-cells = <0>;
            max3421: max3421@1 {
                reg = <1>;	//CS 1
                spi-max-frequency = <20000000>;
                compatible = "maxim,max3421";
                pinctrl-names = "default";
                pinctrl-0 = <&max3421_pins>;
                interrupt-parent = <&gpio>;
                interrupts = <25 0x2>; 		//GPIO25, high-to-low
                maxim,vbus-en-pin = <1 1>;	//MAX GPOUT1, active high
            };
        };
    };

    __overrides__ {
        spimaxfrequency = <&max3421>,"spi-max-frequency:0";
        interrupt = <&max3421_pins>,"brcm,pins:0",<&max3421>,"interrupts:0";
        vbus-en-pin = <&max3421>,"maxim,vbus-en-pin:0";
        vbus-en-level = <&max3421>,"maxim,vbus-en-pin:4";
    };
};
EOF
# -------------------------------------
printf "edit ./arch/arm/boot/dts/overlays/Makefile insert max3421-hcd.dts above matching line max98357a\n"
# edit file ./arch/arm/boot/dts/overlays/Makefile
# (make sure the backslashes are escaped properly; these quoted literal strings contain a literal backslash character at the end)
# find line containing "	max98357a.dtbo \"
#   insert new line above that one, containing "	max3421-hcd.dts \"
ex ./arch/arm/boot/dts/overlays/Makefile <<EOF
" /pattern/ -- find pattern match"
" i -- insert text given on subsequent lines, until a '.'-only line"
" insert/append a line ending in a backslash must use four backslashes"
:/max98357a.dtbo/i
	max3421-hcd.dtbo \\\\
.
" wq -- Write and Quit"
:wq
EOF
#
# -------------------------------------
printf "edit ./arch/arm/boot/dts/overlays/Makefile append spi0-max3421e.dtbo below matching line spi0-2cs\n"
# edit file ./arch/arm/boot/dts/overlays/Makefile
# (make sure the backslashes are escaped properly; these quoted literal strings contain a literal backslash character at the end)
# find line containing "	spi0-2cs.dtbo \"
#   insert new line below that one, containing "	spi0-max3421e.dtbo \"
ex ./arch/arm/boot/dts/overlays/Makefile <<EOF
" /pattern/ -- find pattern match"
" a -- append text below, given on subsequent lines, until a '.'-only line"
" insert/append a line ending in a backslash must use four backslashes"
:/spi0-2cs.dtbo/a
	spi0-max3421e.dtbo \\\\
.
"      "
" wq -- Write and Quit"
:wq
EOF
#
# -------------------------------------

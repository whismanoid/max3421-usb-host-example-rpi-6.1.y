# max3421-usb-host-example-rpi-6.1.y

Maxim MAX3421e USB host example (hcd device driver integration test) on Raspberry Pi (kernel 6.1.y)

The max3421-hcd firmware driver is part of the standard linux kernel source code, and has been for several years.
The source code is located here:

https://github.com/torvalds/linux
  - drivers/usb/host/max3421-hcd.c
  - include/linux/platform_data/max3421-hcd.h
  - Documentation/devicetree/bindings/usb/maxim,max3421.txt

What I did here was just a small integration project to enable building that module and connecting it to some specific hardware interface pins, as a test/demo.
Different hardware platforms will require adjustments to the device tree, specifying which spi bus connects to the max3421 device itself.

I built the kernel 6.1 (sublevel 31) self-hosted on the Raspberry Pi 3, with one change to the default configuration file, 
`CONFIG_USB_MAX3421_HCD=m`, to make the system enable the MAX3421 device driver module (normally omitted from the standard build).
This option can be enabled using the `make menuconfig` configuration GUI, then select `Device Drivers` | `USB Support` | `MAX3421 HCD (USB-over-SPI) support` and set it to `<M>`

Additionally, I added a Device Tree Overlay `spi0-max3421e` to connect the max3421-hcd device driver to the hardware pins.

After building and installing the updated kernel, I updated the boot config.txt to use the overlay: `dtoverlay=spi0-max3421e`

Some useful commands:

`CTRL+ALT+T` brings up a shell window (command-line interface).

````
    lsusb -v --tree
````
lists the attached USB devices, verbose, printed as a tree

````
    dmesg
````
prints the list of kernel messages

````
    dmesg -H --follow
````
continuously prints kernel messages, including new messages

Plugging in a USB flash drive will automatically mount into the file system.

# Hardware

The MAX3421E Evaluation Board was adapted using a small, hand-wired transition board.
The MAX3421E Evaluation Board was modified by adding a wire <b> from U3 pin ___ to U3 pin ___ </b> so that the USB-A host connector would provide +5V power output.
The Raspberry Pi 3A+ 40-pin connector provided +3.3V and +5.0V power supplies to the board, as well as SPI communications and interrupt handling.

```
# Interface Hardware         Top View, board edge here-->|                  
#                                    RASPBERRY Pi3 A+/B+ |                  
#       to MAX3421EVKIT                     +--PI3-J8--+ |                  
# A        +----J4----+                3.3V |[01]  [02]| |A 5.0V            
# B   3.3V |[01]  [02]| 3.3V        sda g2  | 03   [04]| |B 5.0V            
# C        | 03    04 |             scl g3  | 05   [06]| |C GND             
# D        | 05    06 | p.sck           g4  | 07    08 | |D g14 txd         
# E        | 07    08 | p.miso          GND |[09]   10 | |E g15 rxd         
# F        | 09    10 | p.mosi          g17 | 11    12 | |F g18             
# G H.GPX  | 11    12 | p.ssn           g27 | 13   [14]| |G GND             
# H        | 13    14 |                 g22 | 15    16 | |H g23             
# I        | 15    16 | p.resn         3.3V |[17]   18 | |I g24             
# J        | 17    18 | H.RESN   H.MOSI G10 |[19]  [20]| |J GND             
# K        | 19    20 |          H.MISO G9  |[21]  [22]| |K G25 INT H.INT   
# L        | 21   [22]| H.INT    H.SCK  G11 |[23]  [24]| |L G8  CE0         
# M        | 23    24 |                 GND |[25]  [26]| |M g7  CE1 H.SSN   
# N  p.int | 25   [26]| H.SSN         id.sd | 27    28 | |N id.sc           
# O H.SCK  |[27]   28 |                 g5  | 29   [30]| |O GND             
# P H.MISO |[29]   30 | p.gpx           g6  | 31    32 | |P g12             
# Q H.MOSI |[31]   32 |                 g13 | 33   [34]| |Q GND             
# R   5.0V |[33]  [34]| 5.0V            g19 | 35    36 | |R g16             
# S    GND |[35]  [36]| GND             g26 | 37    38 | |S g20             
# T        +----J4----+                 GND |[39]   40 | |T g21             
#                                           +--PI3-J8--+ |                  
#
#   Note: MAX3421EVKIT reset signal H.RESN must be driven by 3.3V
#   Note: MAX3421EVKIT chip select signal H.SSN is driven by spi0.1 = CE1 = GPIO G7
#
```

# Building the project

~~~
mkdir ~/max3421-usb-host-example-rpi-6.1.y
cd ~/max3421-usb-host-example-rpi-6.1.y
git clone git@github.com:whismanoid/max3421-usb-host-example-rpi-6.1.y.git .
. ~/max3421-usb-host-example-rpi-6.1.y/step1_install_tools.sh
. ~/max3421-usb-host-example-rpi-6.1.y/step2_clone_sources.sh
. ~/max3421-usb-host-example-rpi-6.1.y/step3_configure.sh
. ~/max3421-usb-host-example-rpi-6.1.y/step4_build.sh
. ~/max3421-usb-host-example-rpi-6.1.y/step5_test.sh
~~~~


# TODO items

  - hardware modification adding wire from U3 pin ___ to U3 pin ___
  - commands / shell script for downloading source code and generating default configuration
  - commands / ex script for editing source code to enable max3421-hcd device driver support
  - commands / shell script for building and installing kernel
  - commands / ex script for boot config file
  - investigate isolated 12M USB by pairing MAX3421E with sutable ADUMxxxx digital isolator?

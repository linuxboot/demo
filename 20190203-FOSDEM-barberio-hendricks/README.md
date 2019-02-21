# LinuxBoot demo at FOSDEM

This directory collects scripts, configuration files and other code used for the
LinuxBoot demo at FOSDEM 2019.

## How to set up the demo

I used two Qemu virtual machines connected via a bridge.

The first VM will act as a server, and will run:
* a DHCPv6 server (config file for KEA 6: [kea6.conf](config/kea6.conf))
* a Route Advertisement daemon (config file for radvd: [radvd.conf](config/radvd.conf))
* an HTTP server (source code for a minimal server: [server/main.go](server/main.go))
* a network boot program (NBP) to build and copy to the HTTP server directory (see my dummy [netinstaller](netinstaller) based on [u-root](https://u-root.tk))


The second VM will act as a client, and will run our coreboot + LinuxBoot firmware. Use the following steps:
* fetch the necessary code (u-root, Linux, coreboot) (see the [00-fetch.sh](scripts/00-fetch.sh) script)
* build u-root, Linux and coreboot for Qemu (see the [01-build.sh](scripts/01-build.sh) script)
* run it! (see the [02-run.sh](scripts/02-run.sh) script)


## Links

For more information:
* [Open Source Firmware at Facebook](https://fosdem.org/2019/schedule/event/open_source_firmware_at_facebook/) talk at [FOSDEM 2019](https://fosdem.org/2019) on March 3rd 2019
* [Video of the talk + demo](https://video.fosdem.org/2019/K.4.401/open_source_firmware_at_facebook.mp4)
* [Slides of the talk](slides/20190203-FOSDEM-LinuxBoot_Open_Source_Firmware_at_Facebook-Barberio-Hendricks.pdf) ([alternative link](https://insomniac.slackware.it/static/2019_fosdem_linuxboot_at_facebook.pdf))


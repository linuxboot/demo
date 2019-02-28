# LinuxBoot demo at OCP Summit

This directory collects scripts, configuration files and other code used for the
LinuxBoot demo at OCP Summit 2019.

## How to set up the demo

### Hardware

Material:
 - An OCP winterfell server
 - A Raspberry-pi to act as a server (for dhcp, tftp and apt proxy or apt mirror)

Connections:
 - The RJ-45 of the winterfell is connected to the one of the Raspberry-pi
 - The debug port of winterfell is connected to the Raspberry-pi with a usb-serial adaptor

### Setup

Use the following steps:
* copy your original winterfell bios image to `blobs/winterfell.rom`
* fetch the necessary code (`heads`, `u-root`, `linuxboot`, Debian's `netboot`) (see the [00-fetch.sh](scripts/00-fetch.sh) script), note that `heads` will also download a few more packages during build.
* build a `linuxboot` image from `heads` (see the [01-build.sh](scripts/01-build.sh) script)

* copy and update the `inventory.ini` file for ansible to deploy the server
* your server must have 2 network interfaces:
  * one for managing and internet access (wifi on the pi with it's address in the inventory as `ansible_host`)
  * the second to be connected on the winterfell (`my_net_device` in the inventory)
* deploy the server (see the [02-deploy.sh](scripts/02-deploy.sh) script)
* deploy the gui configuration on the Raspberry-pi (02-deploy.sh ../deploy/setup-gui.yml)

This can be summarized as follows:
``` shell
cp path_to/winterfell.rom blobs/winterfell.rom
mkdir build
cd build
../script/00-fetch.sh
../script/01-build.sh
cp ../deploy/my-pi.ini inventory.ini
../scripts/02-deploy.sh
../scripts/02-deploy.sh ../deploy/setup-gui.yml
```

### Setup for serving without internet access

Once debian has been installed on the winterfell server using the proxy `http://192.168.142.2:3142/`, `apt-cacher-ng` will have cached the necessary files and you can setup a web server to act as a mirror:
* deploy the apt mirror configuration on the server (02-deploy.sh ../deploy/setup-localmirror.yml)
  ``` shell
  ../scripts/02-deploy.sh ../deploy/setup-localmirror.yml
  ```

Now you can install again using the local mirror, it is simply named `mirror`.

**Note:**
- *This will set the server to answer its own ip for `mirror` as well as `security.debian.org` each serving the corresponding content.*
- *To revert the DNS spoofing, deploy the basic configuration again:*
  ```shell
  ../scripts/02-deploy.sh
  ```

## Running the demo

On the installed Raspberry-pi you will have a [Linuxboot-Demo.txt](deploy/files/Linuxboot-Demo.txt) on the desktop that you can display during the event.
The icon for `Putty` and `Wireshark` are also installed on the desktop for quick access.

## Side note

The VM setup with `my-kvm.ini` can be used with a linuxboot build similar to the one from FOSDEM demo to reproduce this demo on VM only.

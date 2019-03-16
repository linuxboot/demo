#!/bin/bash -exu

(cd webserver ; go build)

# Create the u-root initramfs with systemboot tools
rm -f /tmp/initramfs.linux_amd64.cpio
rm -f /tmp/initramfs.linux_amd64.cpio.xz
u-root \
    -build=bb \
    -files /usr/bin/strace \
    core \
    github.com/systemboot/systemboot/{uinit,localboot,netboot}

xz --check=crc32 --lzma2=dict=512KiB /tmp/initramfs.linux_amd64.cpio

# Generate some to embed in coreboot, and to be passed to a webserver for TLS
bash ./certs.sh

# build a kernel with the provided initramfs. The CONFIG_INITRAMFS parameter is hardcoded
# in the provided linux config file to point to /tmp/initramfs.linux_amd64.cpio . Adjust
# it if necessary.
KERNEL_VER=4.19.6
cd "linux-${KERNEL_VER}"
make -j$(nproc)

# build coreboot for qemu with the provided config file.
cd ../coreboot/
make
pwd


# Write VPD variables. These will be available read-only via /sys/firmware/vpd/*
# RW_VPD partition
 vpd -f build/coreboot.rom -i RW_VPD -O
 vpd -f build/coreboot.rom -i RW_VPD -s 'LinuxBoot=IsCool'
# RO_VPD partition
 vpd -f build/coreboot.rom -i RO_VPD -O
 vpd -f build/coreboot.rom -i RO_VPD -s 'Boot0000={"type":"netboot","method":"dhcpv6"}'
 vpd -f build/coreboot.rom -i RO_VPD -g Boot0000
 base64 < ../../rootCA.crt > rootCA.crt.base64
 vpd -f build/coreboot.rom -i RO_VPD -S ca_certs=rootCA.crt.base64


echo 'Image built under coreboot/build/coreboot.rom'

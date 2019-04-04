#!/bin/bash -exu

# Create the u-root initramfs with systemboot tools
rm -f /tmp/initramfs.linux_amd64.cpio
rm -f /tmp/initramfs.linux_amd64.cpio.xz
u-root \
    -build=bb \
    -files /usr/bin/strace \
    core \
    github.com/systemboot/systemboot/{uinit,localboot,netboot}

xz --check=crc32 --lzma2=dict=512KiB /tmp/initramfs.linux_amd64.cpio

# build a kernel with the provided initramfs. The CONFIG_INITRAMFS parameter is hardcoded
# in the provided linux config file to point to /tmp/initramfs.linux_amd64.cpio . Adjust
# it if necessary.
KERNEL_VER=4.19.6
cd "linux-${KERNEL_VER}"
make -j$(nproc)

# build coreboot for qemu with the provided config file.
cd ../coreboot/
BUILD_LANGUAGES=c CPUS=$(nproc) make crossgcc-i386
make
cd ..

# Write VPD variables. These will be available read-only via /sys/firmware/vpd/*
# RW_VPD partition
vpd -f coreboot/build/coreboot.rom -i RW_VPD -O
vpd -f coreboot/build/coreboot.rom -i RW_VPD -s 'LinuxBoot=IsCool'
# RO_VPD partition
vpd -f coreboot/build/coreboot.rom -i RO_VPD -O
vpd -f coreboot/build/coreboot.rom -i RO_VPD -s 'Boot0000={"type":"netboot","method":"dhcpv6"}'
vpd -f coreboot/build/coreboot.rom -i RO_VPD -g Boot0000

echo 'Image built under coreboot/build/coreboot.rom'

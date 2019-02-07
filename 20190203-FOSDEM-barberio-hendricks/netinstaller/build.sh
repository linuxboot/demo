#!/bin/bash
GOPATH="$GOPATH:$PWD"
u-root \
    -build=bb \
    -o installer.cpio \
    core \
    uinit
rm -f installer.cpio installer.cpio.xz
xz --check=crc32 --lzma2=dict=512KiB installer.cpio

cd linux-4.19.6
make -j$(nproc)
cp arch/x86/boot/bzImage ../installer


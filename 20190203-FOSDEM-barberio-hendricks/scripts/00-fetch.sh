#!/bin/bash -exu

get_coreboot() {
    if [ ! -e coreboot ]
    then
        git clone https://review.coreboot.org/coreboot.git
    fi
    cp ../config/coreboot-config coreboot/.config
    (
        cd coreboot
        git checkout tags/4.9
    )
}

KERNEL_VER=4.19.6

get_kernel() {
    if [ ! -e "linux-${KERNEL_VER}" ]
    then
        wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VER}.tar.xz
        tar xvJf linux-${KERNEL_VER}.tar.xz
    fi
    cp ../config/linux-config linux-${KERNEL_VER}/.config
}

get_uroot() {
    which u-root 2>&1 > /dev/null
    if [ $? -ne 0 ]
    then
        echo '[*] u-root is missing. Install it with `go get -u github.com/u-root/u-root'
    fi
}

get_coreboot
get_kernel
get_uroot

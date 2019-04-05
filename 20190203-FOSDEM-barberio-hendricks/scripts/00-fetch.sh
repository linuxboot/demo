#!/bin/bash -exu

get_coreboot() {
    if [ ! -e coreboot ]
    then
        git clone https://review.coreboot.org/coreboot.git
        # cherry-pick VPD-on-Qemu patch, https://review.coreboot.org/c/coreboot/+/32087
        (cd coreboot && \
            git fetch https://review.coreboot.org/coreboot refs/changes/87/32087/6 && \
            git cherry-pick FETCH_HEAD
        )
        # Stick on the cherry-picked branch to apply a patch that enables VPD on QEMU
        # TODO: remove the above cherry-pick and uncomment the block below once the
        # patch above is merged.
        # (
        #    cd coreboot
        #    git checkout tags/4.9
        # )
    fi
    cp ../config/coreboot-config coreboot/.config

}

KERNEL_VER=4.19.6

get_kernel() {
    if [ ! -e "linux-${KERNEL_VER}" ]
    then
        wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VER}.tar.xz
    fi
    tar xvJf linux-${KERNEL_VER}.tar.xz
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

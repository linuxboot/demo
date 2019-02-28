#!/bin/bash -exu

# force rebuild rootfs
rm -f heads/build/winterfell/u-root.cpio

cd heads
UROOT_PXE_CMD="mount boot cat insmod uinit init elvish ls lddfiles ln losetup lsmod cat chmod chroot cmp comm console cp cpio msr dmesg ip dhclient umount pxeboot"

time make BOARD=winterfell CONFIG_UROOT=y MAKE_JOBS="-j20 --max-load 20" UROOT_CMDS="$UROOT_PXE_CMD" INITRD_SPLIT=3250000

#
echo Your image is ready in `heads/build/winterfell/linuxboot.rom`
echo
echo You can flash it !
echo flashrom -p dediprog -w heads/build/winterfell/linuxboot.rom

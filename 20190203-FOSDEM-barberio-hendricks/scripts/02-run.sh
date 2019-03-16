#!/bin/bash -exu
if [ $UID -ne 0 ]
then
    sudo $0 $@
    exit $?
fi

./webserver/webserver &
echo "Webserver launched" 

FIRMWARE=coreboot/build/coreboot.rom

qemu-system-x86_64 \
    -M q35 \
    -bios "${FIRMWARE}" \
    -m 1024 \
    -enable-kvm \
    -nographic \
    -hda /home/johnlooney/debian_squeeze_i386_standard.qcow2 \
    -netdev tap,script=/dev/shm/run.sh,downscript=no,id=net0 -device e1000,netdev=net0 \
    -object rng-random,filename=/dev/urandom,id=rng0 \
    -device virtio-rng-pci,rng=rng0 \
    $@

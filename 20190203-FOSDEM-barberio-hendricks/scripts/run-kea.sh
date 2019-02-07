#!/bin/bash
if [ $UID -ne 0 ]
then
    sudo $0 $@
    exit $?
fi

if [ ! -d kea ]
then
    mkdir kea
fi
if [ ! -d /var/run/kea ]
then
    mkdir /var/run/kea
fi

ip6tables -P INPUT ACCEPT
iptables -P INPUT ACCEPT
sudo kea-dhcp6 -c kea6.conf -d


#!/bin/bash -exu

# get specific version of heads for reproducible demo
get_heads() {
    if [ ! -e heads ]
    then
        git clone https://github.com/JulienVdG/heads.git -b 20190314-OCPSummit
    fi
    cp ../blobs/winterfell.rom heads/blobs/
    (
        cd heads
        git checkout 20190314-OCPSummit
    )
}

# get specific version of u-root for reproducible demo
get_uroot(){
    if [ ! -e heads/build/go/src/github.com/u-root/u-root ]
    then
	mkdir -p heads/build/go/src/github.com/u-root
	cd heads/build/go/src/github.com/u-root
    	git clone https://github.com/JulienVdG/u-root.git -b 20190314-OCPSummit u-root
	cd -
    fi
    (
    	cd heads/build/go/src/github.com/u-root/u-root
        git checkout 20190314-OCPSummit
    )
}

# get specific version of linuxboot for reproducible demo
get_linuxboot(){
    if [ ! -e heads/build/linuxboot-git ]
    then
	mkdir -p heads/build
	cd heads/build
    	git clone https://github.com/JulienVdG/linuxboot.git -b 20190314-OCPSummit linuxboot-git
	cd -
    fi
    (
    	cd heads/build/linuxboot-git
        git checkout 20190314-OCPSummit
    )
    # tell heads we did it already
    touch heads/build/linuxboot-git/.canary
}

get_debian_netboot() {
    if [ ! -e "netboot.tar.gz" ]
    then
	wget http://ftp.fr.debian.org/debian/dists/stretch/main/installer-amd64/current/images/netboot/netboot.tar.gz
    fi
}

get_heads
get_uroot
get_linuxboot
get_debian_netboot

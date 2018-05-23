#!/bin/bash
apt install build-essential git ncurses-dev python qemu-system-arm qemu-system-x86 qemu-utils libssl-dev unzip bc qemu-system-i386 libelf-dev bison flex pmount
echo "/dev/loop0" >> /etc/pmount.allow


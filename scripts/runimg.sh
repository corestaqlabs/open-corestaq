#!/bin/bash

qemu-system-arm -M vexpress-a9 -smp 1 -m 256 -kernel "$1" -dtb vexpress-v2p-ca9.dtb -drive file="$2",if=sd,format=raw -append "console=ttyAMA0,115200 root=/dev/mmcblk0" -serial stdio -net nic,model=lan9118 -net user

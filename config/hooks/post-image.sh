#!/bin/bash
echo "post-image.sh"
rm -rf ../output/*

dd if=/dev/zero of=output/images/sys.conf bs=1M count=8
mkfs.ext2 -m 0 -L configfs output/images/sys.conf

dd if=/dev/zero of=output/images/bootfs.img bs=1M count=64
mkfs.ext2 -m 0 -L bootfs output/images/bootfs.img
mkdir -p output/bootfs
sudo mount output/images/bootfs.img output/bootfs

configs/board/hooks/post-image.sh

sudo cp output/images/rootfs.squashfs output/bootfs/sys.img
sudo cp output/images/sys.conf output/bootfs/sys.conf
sudo umount output/bootfs && sync

cp output/images/rootfs.ext2 ../output/corefs.img
cp output/images/rootfs.tar ../output/sysfs.tar && gzip ../output/sysfs.tar
cp output/images/rootfs.squashfs ../output/sys.img
cp output/images/bootfs.img ../output/
cp output/images/sdcard.img ../output/

support/scripts/genimage.sh -c configs/board/config/sd.conf


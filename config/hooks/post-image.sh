#!/bin/bash
WHOAMI=`whoami`
uid=$(id -u $WHOAMI)
gid=$(id -g $WHOAMI)

echo "post-image.sh"
rm -rf ../output/*

dd if=/dev/zero of=output/images/sys.conf bs=1M count=8
mkfs.ext2 -m 0 -L configfs -E root_owner=$uid:$gid output/images/sys.conf

dd if=/dev/zero of=output/images/bootfs.img bs=1M count=64
mkfs.ext2 -m 0 -L bootfs -E root_owner=$uid:$gid output/images/bootfs.img
mkdir -p output/bootfs

sudo mount output/images/bootfs.img output/bootfs

configs/board/hooks/post-image.sh

cp output/images/rootfs.squashfs output/bootfs/sys.img
cp output/images/sys.conf output/bootfs/sys.conf

sudo umount output/bootfs && sync

cp output/images/rootfs.ext2 ../output/corefs.img
cp output/images/rootfs.tar ../output/corefs.tar && gzip ../output/corefs.tar
cp output/images/rootfs.squashfs ../output/sys.img

support/scripts/genimage.sh -c configs/board/config/sd.conf

cp output/images/bootfs.img ../output/
cp output/images/iotfapOS.img ../output/


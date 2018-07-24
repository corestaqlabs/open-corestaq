#!/bin/bash
WHOAMI=`whoami`
uid=$(id -u $WHOAMI)
gid=$(id -g $WHOAMI)

echo "post-image.sh"
rm -rf ../output/*

dd if=/dev/zero of=output/images/sys.conf bs=1M count=8
mkfs.ext2 -m 0 -L configfs -E root_owner=$uid:$gid output/images/sys.conf

dd if=/dev/zero of=output/images/recoveryfs.img bs=1M count=62
mkfs.ext2 -m 0 -L bootfs -E root_owner=$uid:$gid output/images/recoveryfs.img
mkdir -p output/recoveryfs

sudo mount output/images/recoveryfs.img output/recoveryfs

configs/board/hooks/post-image.sh

cp output/images/rootfs.squashfs output/recoveryfs/sys.img

sudo umount output/recoveryfs && sync

cp output/images/rootfs.ext2 ../output/corefs.img
cp output/images/rootfs.tar ../output/corefs.tar && gzip ../output/corefs.tar
cp output/images/rootfs.squashfs ../output/sys.img
cp output/images/rootfs.cpio.gz ../output/recovery.sys

support/scripts/genimage.sh -c configs/sd.conf

cp output/images/iotfapOS.img ../output/


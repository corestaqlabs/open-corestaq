#!/bin/bash
echo "post-image.sh"
rm -rf ../output/*

configs/board/hooks/post-image.sh

cp output/images/rootfs.ext2 ../output/corefs.img

cp output/images/rootfs.tar ../output/corefs.tar && gzip ../output/corefs.tar

cp output/images/rootfs.squashfs ../output/corefs.sys

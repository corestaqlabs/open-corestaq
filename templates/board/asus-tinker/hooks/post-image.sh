#!/bin/bash
echo "board template post-image.sh"

MKIMAGE=$HOST_DIR/bin/mkimage

sudo cp output/images/zImage output/bootfs/sys.k
sudo cp output/images/rk3288-miniarm.dtb output/bootfs/sys.dtb 
sudo install -m 0644 -D configs/board/config/boot.conf output/bootfs/boot/extlinux/extlinux.conf

cp configs/board/output/* ../output/
cp output/images/zImage ../output/sys.k
cp output/images/rk3288-miniarm.dtb ../output/sys.dtb
cp output/images/u-boot-spl-dtb.bin ../output/uboot-spl.bin
cp output/images/u-boot-dtb.img ../output/uboot-dtb.img

#!/bin/bash
echo "board template post-image.sh"

MKIMAGE=$HOST_DIR/bin/mkimage

sudo cp output/images/zImage output/bootfs/sys.k
sudo cp output/images/rk3288-miniarm.dtb output/bootfs/sys.dtb 
sudo install -m 0644 -D configs/board/config/boot.conf output/bootfs/extlinux/extlinux.conf

cp configs/board/output/* ../output/
cp configs/board/oem-bsp/tinker-uboot.bin.gz output/images/uboot.bin.gz
cp configs/board/oem-bsp/hw_intf.conf output/bootfs/
cp configs/board/oem-bsp/rk3288-miniarm.dtb output/bootfs/
cp configs/board/oem-bsp/rk3288-miniarm.dtb output/images/
cp -R configs/board/oem-bsp/overlays output/bootfs/
gzip -f -d output/images/uboot.bin.gz
cp output/images/zImage ../output/sys.k
cp output/images/rk3288-miniarm.dtb ../output/sys.dtb

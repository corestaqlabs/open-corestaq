#!/bin/bash
echo "board template post-image.sh"

MKIMAGE=$HOST_DIR/bin/mkimage

touch output/images/uboot.bin

sudo cp output/images/zImage output/bootfs/sys.k
sudo cp output/images/vexpress-v2p-ca9.dtb output/bootfs/sys.dtb 

cp configs/board/output/* ../output/
cp output/images/zImage ../output/sys.k
cp output/images/vexpress-v2p-ca9.dtb ../output/sys.dtb

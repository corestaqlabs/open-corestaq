#!/bin/bash
echo "board template post-image.sh"

MKIMAGE=$HOST_DIR/bin/mkimage

dd if=/dev/zero of=output/images/uboot.bin bs=1k count=1024

sudo cp output/images/zImage output/recoveryfs/sys.k
sudo cp output/images/vexpress-v2p-ca9.dtb output/recoveryfs/sys.dtb 

cp configs/board/output/* ../output/
cp output/images/zImage ../output/sys.k
cp output/images/vexpress-v2p-ca9.dtb ../output/sys.dtb

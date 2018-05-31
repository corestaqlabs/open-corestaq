#!/bin/bash
echo "board template post-image.sh"

MKIMAGE=$HOST_DIR/bin/mkimage

dd if=/dev/zero of=output/images/uboot.bin bs=1k count=1024

sudo cp output/images/Image output/bootfs/sys.k

cp configs/board/output/* ../output/
cp output/images/Image ../output/sys.k


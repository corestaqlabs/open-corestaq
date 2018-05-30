#!/bin/bash
echo "board template post-image.sh"

MKIMAGE=$HOST_DIR/bin/mkimage

touch output/images/uboot.bin

sudo cp output/images/Image output/bootfs/sys.k

cp configs/board/output/* ../output/
cp output/images/Image ../output/sys.k


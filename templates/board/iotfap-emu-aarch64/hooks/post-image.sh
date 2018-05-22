#!/bin/bash
echo "board template post-image.sh"

MKIMAGE=$HOST_DIR/bin/mkimage

sudo cp output/images/Image output/bootfs/sys.k

cp configs/board/output/* ../output/
cp output/images/zImage ../output/sys.k


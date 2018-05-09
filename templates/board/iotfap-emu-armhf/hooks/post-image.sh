#!/bin/bash
echo "board template post-image.sh"

cp configs/board/output/* ../output/

cp output/images/zImage ../output/sys.k

cp output/images/vexpress-v2p-ca9.dtb ../output/sys.dtb

#!/bin/bash
echo "board template post-image.sh"

cp configs/board/output/* ../output/

cp output/images/bzImage ../output/sys.k

cp output/images/rk3288-tinker.dtb ../output/sys.dtb

cp output/images/* ../output/

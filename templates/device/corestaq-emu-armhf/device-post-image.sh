#!/bin/bash
# device-post-image.sh - corestaq-emu-armhf

cp template/run-emu.sh output/images/
cp template/run-emu.sh ../output/
cp output/images/zImage ../output/
cp output/images/vexpress-v2p-ca9.dtb ../output/

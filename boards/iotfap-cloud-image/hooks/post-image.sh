#!/bin/bash
echo "board template post-image.sh"

SDIR="$(dirname $0)"

cp -f ${SDIR}/../config/grub.cfg ${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg

support/scripts/genimage.sh -c ${SDIR}/../config/genimg.cfg


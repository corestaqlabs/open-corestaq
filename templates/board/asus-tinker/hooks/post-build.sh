#!/bin/bash
echo "board template post-build.sh"
sudo rm -rf builder/output/target/lib/modules/*
wget -O - https://github.com/iotfap/oem-bsp-repo/raw/master/asus-tinker/modules-2.0.5.tgz | tar -xz -C output/target/lib/modules/
wget -O - https://github.com/iotfap/oem-bsp-repo/raw/master/asus-tinker/firmware-2.0.5.tgz | tar -xz -C output/target/lib/


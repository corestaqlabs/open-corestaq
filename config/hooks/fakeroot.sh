#!/bin/bash
echo "fakeroot.sh"
rm /etc/init.d/S50dropbear /etc/init.d/S50stunnel
rm /etc/udev/hwdb.d/20-pci-vendor-model.hwdb /etc/udev/hwdb.d/20-OUI.hwdb


#!/bin/bash
# fakeroot.sh

corestaq_fakeroot () {
	echo "corestaq-fakeroot.sh"
}

platform_fakeroot () {
	echo "platform-fakeroot.sh"
	[ -f template/platform-fakeroot.sh ] && template/platform-fakeroot.sh
}

device_fakeroot () {
	echo "device-fakeroot.sh"
	[ -f template/device-fakeroot.sh ] && template/device-fakeroot.sh
}

###
corestaq_fakeroot
platform_fakeroot
device_fakeroot

exit 0


#!/bin/bash
# post-build.sh

corestaq_post_build () {
	echo "corestaq-post-build.sh"
}

platform_post_build () {
	echo "platform-post-build.sh"
	template/platform-post-build.sh
}

device_post_build () {
	echo "device-post-build.sh"
	template/device-post-build.sh
}


###
corestaq_post_build
[ -f template/platform-post-build.sh ] && platform_post_build
[ -f template/device-post-build.sh ] && device_post_build

exit 0


#!/bin/bash
# post-image.sh

corestaq_post_image () {
	echo "corestaq-post-image.sh"
}

platform_post_image () {
	echo "platform-post-image.sh"
	[ -f template/platform-post-image.sh ] && template/platform-post-image.sh
}

device_post_image () {
	echo "device-post-image.sh"
	[ -f template/device-post-image.sh ] && template/device-post-image.sh
}

create_output () {
	echo "Populating Output"
	cp template/README.md output/
	tar -C output/images --strip-components=3 -xf output/images/rootfs.tar ./usr/lib/modules
	[ -d output/images/modules/* ] && cd output/images && tar -czf modules.tgz modules && tar -f rootfs.tar --delete ./usr/lib/modules
	mv rootfs.tar.gz rootfs-modules.tgz && gzip rootfs.tar && mv rootfs.tar.gz rootfs-bare.tgz
	cp rootfs-bare.tgz ../../../output/
	cp rootfs-modules.tgz ../../../output/
	cp modules.tgz ../../../output/
	cp rootfs.cpio.gz ../../../output/rootfs.initrd
	cp rootfs.squashfs ../../../output/rootfs.sqfs
	cp rootfs.cloop ../../../output/
	cp rootfs.ext2 ../../../output/
}

###
corestaq_post_image
platform_post_image
device_post_image
create_output

exit 0


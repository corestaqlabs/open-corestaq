#!/bin/bash
#
# temp build script
#

TARGET="$1"
BUILD="$2"
source board-targets/"$TARGET"/board.conf

build_config () {
	rm -rf corefs-builder/configs/*
	rm -rf corefs-builder/board/*
	rm -rf output/*Image
	rm -rf output/*ext"
	rm -rf output/*dtb"
	rm -rf corefs-builder/system/skeleton/*
	cat board-targets/"$TARGET"/board.conf > corefs-builder/configs/active_defconfig
	cat board-targets/"$TARGET"/config/linux.conf >> corefs-builder/configs/active_defconfig
	cat board-targets/"$TARGET"/config/uboot.conf >> corefs-builder/configs/active_defconfig
	cat config/iotfapOS-core.conf >> corefs-builder/configs/active_defconfig
	cat config/corefs-apps.conf >> corefs-builder/configs/active_defconfig
	cp -r board-targets/"$TARGET"/* corefs-builder/board/
	cp -r config/* corefs-builder/configs/
	cp -r config/skel/* corefs-builder/system/skeleton/
	cp -r board-targets/"$TARGET"/skel/* corefs-builder/system/skeleton/
}

build () {
	case "$BUILD" in 
		all)
			make_all
			;;
		linux)
			make_linux
			;;
		corefs)
			make_corefs
			;;
		uboot)
			make_uboot
			;;
		clean)
			make_clean
			;;
		*)
			make_none
			;;
esac
}

make_all () {
	cd corefs-builder
	make active_defconfig
	make
	cp output/images/* ../output/
	tar -czf $TB_ID-all.tgz ../output
	mv $TB_ID-all.tgz ../output/
}

make_corefs () {
	sed -i 's/BR2_LINUX_KERNEL=y/BR2_LINUX_KERNEL=n/g' corefs-builder/configs/active_defconfig
	cd corefs-builder
	make active_defconfig
	make
	cp output/images/* ../output/
	tar -czf $TB_ID-corefs.tgz ../output
	mv $TB_ID-corefs.tgz ../output/
}

make_linux () {
	cd corefs-builder
	make active_defconfig
	make linux-build
	cp output/images/* ../output/
	tar -czf $TB_ID-linux.tgz ../output
	mv $TB_ID-linux.tgz ../output/
}

make_uboot () {
	echo "booted"
}

make_clean () {
	cd corefs-builder
	make clean
}

make_none () {
	cd corefs-builder
	make active_defconfig
	make menuconfig
}

build_help () {
	echo 'Use: build.sh board-target [buildtype]'
	echo ' buildtypes (optional):'
	echo '   all, corefs, linux, uboot, clean'
	echo ' board-targets (required):'
	ls board-targets/*/board.conf | cut -d '/' -f 2 | sed 's/^/   /g'
}

# Check Target Exists
if [ -f board-targets/"$TARGET"/board.conf ]; then
	build_config
	build
else
	build_help
fi

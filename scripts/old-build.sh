#!/bin/bash
#
# temp build script
#

TARGET="$1"
BUILD="$2"

build_config () {
	rm -rf corefs-builder/configs/*
	rm -rf corefs-builder/board/*
	rm -rf output/*
	rm -rf corefs-builder/system/skeleton/*
	cat boards/"$TARGET"/board.conf > corefs-builder/configs/active_defconfig
	cat boards/"$TARGET"/config/linux.conf >> corefs-builder/configs/active_defconfig
	cat boards/"$TARGET"/config/uboot.conf >> corefs-builder/configs/active_defconfig
	cat config/iotfapOS-core.conf >> corefs-builder/configs/active_defconfig
	cat config/iotfapOS-custom.conf >> corefs-builder/configs/active_defconfig
	cp -r boards/"$TARGET"/* corefs-builder/board/
	cp -r config/* corefs-builder/configs/
	cp -r config/skel/* corefs-builder/system/skeleton/
	cp -r boards/"$TARGET"/skel/* corefs-builder/system/skeleton/
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
}

make_corefs () {
	sed -i 's/BR2_LINUX_KERNEL=y/BR2_LINUX_KERNEL=n/g' corefs-builder/configs/active_defconfig
	cd corefs-builder
	make active_defconfig
	make
	cp output/images/* ../output/
	tar -czf $TB_ID-corefs.tgz ../output
}

make_linux () {
	cd corefs-builder
	make active_defconfig
	make linux-build
	cp output/images/* ../output/
	tar -czf $TB_ID-linux.tgz ../output
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
}

build_help () {
	echo 'Use: build.sh board-target [buildtype]'
	echo ' buildtypes (optional):'
	echo '   all, corefs, linux, uboot, clean'
	echo ' board-targets (required):'
	ls boards/*/board.conf | cut -d '/' -f 2 | sed 's/^/   /g'
}

# Check Target Exists
if [ "$TARGET" == "clean" ]; then
	make_clean
else
	if [ -f boards/"$TARGET"/board.conf ]; then
		source boards/"$TARGET"/board.conf
		build_config
		build
	else
		build_help	
	fi
fi

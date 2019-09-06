#!/bin/bash

CSQBCMD="$1"
CSQ_DEVICE="$2"
CSQ_PLATFORM=""
CSQTMPL="buildstaq/template/"
DEVICETPL="templates/device"
PLATFORMTPL="templates/platform"

helpme () {
    echo 'Use:'
    echo './corestaq-build.sh build-command [device-template]'
    echo ' '
    echo 'Build Commands'
    echo '   [s]etup [device-template] - configures build system for selected device ready for use'
    echo '   [a]ll [device-template] - configures and builds all output images for selected device'
    echo '   [l]inux [device-template] - builds linux kernel & modules for selected device'
    echo '   [d]ownload [device-template] - downloads all sources for selected template'
    echo '   [e]dit - edit current template'
    echo '   [b]uild - (re)builds current template'
    echo '   [x|xx]clean|distclean - cleans template or full build environment, board template not needed'
    echo ' '
    echo 'Available Device Templates (required):'
    ls "$DEVICETPL"/*/device.conf | cut -d '/' -f 3 | sed 's/^/   /g' | grep -v template
    echo ' '
}

activate_config () {
    source "$DEVICETPL"/"$CSQ_DEVICE"/device.conf
    source "$PLATFORMTPL"/"$CSQ_PLATFORM"/toolchain.conf
    rm -rf "$CSQTMPL"*
    cp config/corestaq-busybox.conf buildstaq/template/
    cp scripts/build-hooks/* buildstaq/template/
    cp "$PLATFORMTPL"/"$CSQ_PLATFORM"/* buildstaq/template/
    cp "$DEVICETPL"/"$CSQ_DEVICE"/* buildstaq/template/
    chmod +x buildstaq/template/*.sh

    cat config/build.conf > buildstaq/template/corestaq_defconfig
    cat buildstaq/template/platform.conf >> buildstaq/template/corestaq_defconfig 
    cat buildstaq/template/device.conf >> buildstaq/template/corestaq_defconfig

    if [ "$CSQ_TOOLCHAIN" == "local" ]; then
    	cat config/toolchain-local.conf >> buildstaq/template/corestaq_defconfig
    elif [ "$CSQ_TOOLCHAIN" == "external" ]; then
    	cat config/toolchain-external.conf >> buildstaq/template/corestaq_defconfig
    else
    	cat config/toolchain-corestaq.conf >> buildstaq/template/corestaq_defconfig
    fi
    
    cat config/corestaq-base.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/kernel.conf >> buildstaq/template/corestaq_defconfig
    cat config/mydevice.conf >> buildstaq/template/corestaq_defconfig
    cat config/packages.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/platform-packages.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/device-packages.conf >> buildstaq/template/corestaq_defconfig

    cd buildstaq && make corestaq_defconfig
    cd ..
    
    echo "Build config for $CSQ_DEVICE ready"
}

clean_config () {

    rm -rf "$CSQTMPL"*

    if [ $CSQBCMD = "xx" ] || [ $CSQBCMD = "distclean" ]; then
        cd buildstaq && make -s clean && make -s distclean
        cd ..
    else
        cd buildstaq && make -s clean
        cd ..
    fi
}

download_config () {
    if [ -d pkgcache/src/dl ] && [ ! -d buildstaq/dl ]; then
        echo "Copying local pkgcache"
	cp -Rvf pkgcache/src/dl buildstaq/
    fi

    cd buildstaq && make -s source
    cd ..
}

edit_config () {
    cd buildstaq && make -s menuconfig
    cd ..
}

make_template () {
	if [ -f "$CSQTMPL"corestaq_defconfig ]; then
		rm -rf output/* buildstaq/output/images/modules buildstaq/output/images/root*
    	cd buildstaq && make -s
    	cd ..
    else
    	helpme
    fi
}

make_linux () {
    cd buildstaq && make -s linux
    cd ..
}


####
if [ -f "$DEVICETPL"/"$CSQ_DEVICE"/device.conf ]; then
    case "$CSQBCMD" in
        a|all)
            activate_config
	    	download_config
            make_template
            ;;
        s|setup)
            activate_config
            ;;
        d|download)
            activate_config
            download_config
            ;;
        l|linux)
            activate_config
            make_linux
            ;;
        *)
            helpme
            ;;
    esac
else
    case "$CSQBCMD" in
        x|xx|clean|distclean)
            clean_config
        ;;
        b|build)
            make_template
            ;;
        e|edit)
            edit_config
            ;;
        *)
            helpme
        ;;
    esac
fi




### dependancies



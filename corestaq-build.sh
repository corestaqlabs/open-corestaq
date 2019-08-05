#!/bin/bash

CSQBCMD="$1"
CSQ_DEVICE="$2"
CSQ_PLATFORM=""
CSQTMPL="buildstaq/template/"
DEVICETEMPLATES="templates/device"
PLATFORMTEMPLATES="templates/platform"

activate_config () {
    source "$DEVICETEMPLATES"/"$CSQ_DEVICE"/device.conf
    rm -rf "$CSQTMPL"*
    cp config/* buildstaq/template/
    cp templates/platform/$CSQ_PLATFORM/* buildstaq/template/
    cp templates/device/$CSQ_DEVICE/* buildstaq/template/

    cat buildstaq/template/platform.conf > buildstaq/template/corestaq_defconfig 
    cat buildstaq/template/device.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/build.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/toolchain.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/corestaq-base.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/kernel.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/mydevice.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/packages.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/platform-packages.conf >> buildstaq/template/corestaq_defconfig
    cat buildstaq/template/device-packages.conf >> buildstaq/template/corestaq_defconfig

    cd buildstaq && make corestaq_defconfig
    cd ..
    
    echo "Build config for $CSQ_DEVICE ready"
}


clean_config () {

	rm -rf "$CSQTMPL"*

    if [ $CSQBCMD = "xx" ]; then
        cd buildstaq && make clean && make distclean
        cd ..
    else
        cd buildstaq && make clean
        cd ..
    fi
}

download_config () {
    cd buildstaq && make -s source
}

edit_config () {
    activate_config
    cd builder && make menuconfig
}

make_config () {
    cd builder && make
}

make_toolchain () {
    cd builder && make -s toolchain
}

make_linux () {
    cd buildstaq && make -s linux
}

helpme () {
    echo 'Use:'
    echo './corestaq-build.sh build-command device-template'
    echo ' '
    echo 'Build Commands'
    echo '   [s]etup - configures build system for selected device ready for use'
    echo '   [a]ll - configures and builds all output images for selected device'
    echo '   [c]corefs - builds corefs img, recovery initrd, sd card image - no kernel'
    echo '   [l]inux - builds linux kernel & modules for selected device'
#    echo '   [t]oolchain - configures and builds [t]oolchain for selected device'
    echo '   [d]ownload - downloads all sources for selected build'
    echo '   [e]dit - configures selected board and edit config'
    echo '   [r]ebuild - (re)builds current custom config'
    echo '   [x|xx]clean|distclean - cleans template or full build environment, board template not needed'
    echo ' '
    echo 'Available Device Templates (required):'
    ls "$DEVICETEMPLATES"/*/device.conf | cut -d '/' -f 3 | sed 's/^/   /g' | grep -v template
    echo ' '
}

####
if [ -f "$DEVICETEMPLATES"/"$CSQ_DEVICE"/device.conf ]; then
    case "$CSQBCMD" in
        a|all)
            activate_config
	    download_config
            make_config
            ;;
        s|setup)
            activate_config
            ;;
        d|download)
            activate_config
            download_config
            ;;
        e|edit)
            activate_config
            edit_config
            ;;
        r|rebuild)
            make_config
            ;;
        c|corefs)
            clean_config
            activate_config
            make_config
            ;;
        l|linux)
            clean_config
            activate_config
            make_linux
            ;;
        *)
            helpme
            ;;
    esac
else
    case "$CSQBCMD" in
        x|xx|clean)
            clean_config
        ;;
        *)
            helpme
        ;;
    esac
fi




### dependancies



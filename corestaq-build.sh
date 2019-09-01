#!/bin/bash

CSQBCMD="$1"
CSQ_DEVICE="$2"
CSQ_PLATFORM=""
CSQTMPL="buildstaq/template/"
DEVICETEMPLATES="templates/device"
PLATFORMTEMPLATES="templates/platform"

helpme () {
    echo 'Use:'
    echo './corestaq-build.sh build-command [device-template]'
    echo ' '
    echo 'Build Commands'
    echo '   [s]etup - configures build system for selected device ready for use'
    echo '   [a]ll - configures and builds all output images for selected device'
    echo '   [d]ownload - downloads all sources for selected template'
    echo '   [e]dit - configures selected template and edit config'
    echo '   [b]uild - (re)builds current template'
    echo '   [l]inux - builds linux kernel & modules for selected device'
    echo '   [x|xx]clean|distclean - cleans template or full build environment, board template not needed'
    echo ' '
    echo 'Available Device Templates (required):'
    ls "$DEVICETEMPLATES"/*/device.conf | cut -d '/' -f 3 | sed 's/^/   /g' | grep -v template
    echo ' '
}

activate_config () {
    source "$DEVICETEMPLATES"/"$CSQ_DEVICE"/device.conf
    rm -rf "$CSQTMPL"*
    cp config/corestaq-busybox.conf buildstaq/template/
    cp scripts/build-hooks/* buildstaq/template/
    cp templates/platform/$CSQ_PLATFORM/* buildstaq/template/
    cp templates/device/$CSQ_DEVICE/* buildstaq/template/
    chmod +x buildstaq/template/*.sh

    cat buildstaq/template/platform.conf > buildstaq/template/corestaq_defconfig 
    cat buildstaq/template/device.conf >> buildstaq/template/corestaq_defconfig
    cat config/build.conf >> buildstaq/template/corestaq_defconfig
    
    if [ -f config/toolchain.conf ]; then
    	cat config/toolchain.conf >> buildstaq/template/corestaq_defconfig
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

    if [ $CSQBCMD = "xx" ]; then
        cd buildstaq && make -s clean && make -s distclean
        cd ..
    else
        cd buildstaq && make -s clean
        cd ..
    fi
}

download_config () {
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
if [ -f "$DEVICETEMPLATES"/"$CSQ_DEVICE"/device.conf ]; then
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
        e|edit)
            activate_config
            edit_config
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
        x|xx|clean)
            clean_config
        ;;
        b|build)
            make_template
            ;;
        *)
            helpme
        ;;
    esac
fi




### dependancies



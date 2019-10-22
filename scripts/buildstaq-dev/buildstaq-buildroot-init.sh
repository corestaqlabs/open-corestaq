#!/bin/bash

# CAUTION: This script generates a developer version of the buildstaq
#          that will overwrite the current version and move the existing
#          buildstaq to buildstaq.orig. To revert to normal, just remove
#          or rename the buildstaq folder and mv buildstaq.orig buildstaq
#

BR_URL="https://github.com/buildroot/buildroot"
BR_BASE="$1"
BR_BASE_LIST="2019.02.6 2019.02.5 2019.02.4"
BR_BASE_LIST_DEV="2019.08.1"

helpme () {
	echo "CAUTION: This script generates a developer version of the buildstaq"
	echo "         that will overwrite the current version. The existing buildstaq"
	echo "         has been moved to buildstaq.orig. To revert back, remove or rename"
	echo "         the buildstaq folder and move buildstaq.orig back to buildstaq"
	echo ""
	echo "Builroot versions available:"
	echo "	Stable: $BR_BASE_LIST"
	echo "	Dev: $BR_BASE_LIST_DEV"
	echo "	Git Master: master"
}

download () {
	mv buildstaq buildstaq.orig
	wget -q $BR_URL/archive/$BR_BASE.zip
	unzip -q $BR_BASE.zip 
	mv buildroot-$BR_BASE buildstaq || mv $BR_BASE buildstaq
	rm $BR_BASE.zip
}

patch () {
	echo "Patch..."
	cd buildstaq
	rm -rf board configs
	mkdir template
	sed -i 's/\/configs/\/template/g' Makefile
}


###
if [ "$1" ]; then
	download
	patch
else
	helpme
fi


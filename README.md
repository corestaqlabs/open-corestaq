Use:

	./corestaq-build.sh build-command device-template
 
	Build Commands
	   [s]etup - configures build system for selected device ready for use
	   [a]ll - configures and builds all output images for selected device
	   [c]corefs - builds corefs img, recovery initrd, sd card image - no kernel
	   [l]inux - builds linux kernel & modules for selected device
	   [d]ownload - downloads all sources for selected build
	   [e]dit - configures selected board and edit config
	   [r]ebuild - (re)builds current custom config
	   [x|xx]clean|distclean - cleans template or full build environment, board template not needed
 
Available Device Templates (required):

	   corestaq-emu-aarch64
	   corestaq-emu-armhf
	   corestaq-emu-x86_64
	   corestaq-emu-x86

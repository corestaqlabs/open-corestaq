Use:

```
./corestaq-build.sh build-command [device-template]
 
Build Commands
   [s]etup - configures build system for selected device ready for use
   [a]ll - configures and builds all output images for selected device
   [d]ownload - downloads all sources for selected template
   [e]dit - configures selected template and edit config
   [b]uild - (re)builds current template
   [l]inux - builds linux kernel & modules for selected device
   [x|xx]clean|distclean - cleans template or full build environment, board template not needed
 
Available Device Templates (required):

	   corestaq-emu-aarch64
	   corestaq-emu-armhf
	   corestaq-emu-x86_64
	   corestaq-emu-x86

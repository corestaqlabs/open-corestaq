# iotfapOS-core

    Secure, tiny, embedded Linux compatable system
    #TODO

## About

    #TODO

## Target Boards / platforms in development

##### iotfap developer quemu builds

* iotfap-emu-arfhf (Developer Qemu Image)

* iotfap-emu-aarch64 (Developer Qemu Image)

* iotfap-emu-x86_64 (Developer Qemu Image) #TODO

##### iotfap generic platform targets

* iotfap-rda8810 (Generic rda8810, rda8810-devkit) #TODO

* iotfap-rk3288-miniarm (Generic rk3288-miniarm) #TODO

* iotfap-h2 (Generic Allwinner H2+) #TODO

* iotfap-h3 (Generic Allwinner H3) #TODO

* iotfap-h5 (Generic Allwinner H5) #TODO

##### Supported Target Boards

* asus-tinker (Asus Tinkerboard SD Card) #TODO

* opi-2g (Orange Pi 2G IOT SD Card) #TODO

* opi-2g-nand (Orange Pi 2G IOT NAND) #TODO

* raspi-3 (Raspberry Pi 3 SD Card) #TODO

## Building

    ./build action target board [profile]

Actions: [a]ctivate config, [b]uild target, [c]lean build env, [d]elete ccache, [e]dit corefs

Targets: [i]mage, [c]orefs, [k]ernel, [u]boot

Boards: iotfap-emu-armhf, iotfap-emu-aarch64, etc

Profiles: base, gpio, lamp, mysql, custom, etc [base if blank]

#### Examples

    ./build b i iotfap-emu-aarch64   #build a full system image for arm8 aarch64 qemu

    ./build b k iotfap-emu-armhf   #build a kernel image for arm7 armhf qemu

    ./build a i iotfap-emu-x86_64   #activate config and prepare build, dont make for x86_64 qemu

    ./build c   #clean the build environment config and cache

## Build Output

##### CORE SYSTEM COMPONENTS
* linux kernel image
* uboot image [not for emulator builds]
* corefs/configfs disk image
* corefs tarball
* corefs squashfs [not for emulator builds]

##### OPTIONAL 64MB SD CARD IMAGE [not for emulator builds]
* 2MB uboot reserved with target board uboot
* 32MB corefs with kernel
* 4MB configfs [empty]
* 26MB datafs [empty]

## Pre-built images

#### Check project releases

## FAQ's
    #TODO

## Contributing
    #TODO

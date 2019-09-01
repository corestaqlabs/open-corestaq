qemu-system-x86_64 -M pc -smp 2 -m 512 -kernel bzImage -drive file=rootfs.ext2,if=virtio,format=raw -append "rootwait root=/dev/vda" -net nic,model=virtio -net user

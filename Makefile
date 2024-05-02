the-donuts:
	nix build .#nixosConfigurations.build-qcow2.config.system.build.qcow2
	cp result/nixos.qcow2 root.qcow2
	chmod 644 root.qcow2
	qemu-kvm -name nixos -m 4G -smp 2 -drive cache=writeback,file=root.qcow2,id=drive1,if=none,index=1,werror=report -device virtio-blk-pci,bootindex=1,drive=drive1 -nographic

BUILD_ENVIRONMENT := development
ifneq (,$(filter production,$(MAKECMDGOALS)))
    BUILD_ENVIRONMENT := production
endif

boot: root.qcow2
	qemu-kvm -name nixos -m 4G -smp 2 -drive cache=writeback,file=root.qcow2,id=drive1,if=none,index=1,werror=report -device virtio-blk-pci,bootindex=1,drive=drive1 -nographic

build: root.qcow2

production:
	$(MAKE) build BUILD_ENVIRONMENT=production

root.qcow2: flake.lock flake.nix qcow.nix configuration.nix
	nix build --impure .#nixosConfigurations.build-qcow2-$(BUILD_ENVIRONMENT).config.system.build.qcow2
	cp -f result/nixos.qcow2 root.qcow2
	chmod 644 root.qcow2
	touch flake.lock

.PHONY: production
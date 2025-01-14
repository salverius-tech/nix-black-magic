BUILD_ENVIRONMENT := development
ifneq (,$(filter production,$(MAKECMDGOALS)))
		BUILD_ENVIRONMENT := production
endif

IMAGE_FILE := output/root.qcow2

boot: build
	qemu-kvm -name nixos -m 4G -smp 2 -drive cache=writeback,file=$(IMAGE_FILE),id=drive1,if=none,index=1,werror=report -device virtio-blk-pci,bootindex=1,drive=drive1 -nographic

build: $(IMAGE_FILE)

production:
	$(MAKE) build BUILD_ENVIRONMENT=production

$(IMAGE_FILE) flake.lock: flake.nix qcow.nix configuration.nix
	nix build --impure .#nixosConfigurations.build-qcow2-$(BUILD_ENVIRONMENT).config.system.build.qcow2
	mkdir -p output
	cp -f result/nixos.qcow2 $(IMAGE_FILE)
	chmod 644 $(IMAGE_FILE)
	touch flake.lock

.PHONY: production clean
clean:
	rm -f $(IMAGE_FILE)
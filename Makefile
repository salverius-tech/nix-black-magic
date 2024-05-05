export DOPPLER_TOKEN_FILE := ./dev/.doppler-token
BUILD_ENVIRONMENT := development
ifneq (,$(filter production,$(MAKECMDGOALS)))
		BUILD_ENVIRONMENT := production
		DOPPLER_TOKEN_FILE := ./prod/.doppler-token
endif

IMAGE_FILE := output/root.qcow2

boot: build
	qemu-kvm -name nixos -m 4G -smp 2 -drive cache=writeback,file=$(IMAGE_FILE),id=drive1,if=none,index=1,werror=report -device virtio-blk-pci,bootindex=1,drive=drive1 -nographic

build: $(IMAGE_FILE)

$(IMAGE_FILE): flake.lock
	mkdir -p output
	cp -f result/nixos.qcow2 $(IMAGE_FILE)
	chmod 644 $(IMAGE_FILE)

flake.lock: flake.nix
	@doppler run --token $(shell cat $(DOPPLER_TOKEN_FILE)) -- nix build --impure .#nixosConfigurations.build-qcow2-$(BUILD_ENVIRONMENT).config.system.build.qcow2

.PHONY: production clean
clean:
	rm -f $(IMAGE_FILE)
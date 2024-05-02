{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  boot.kernelParams = ["console=ttyS0"];
  boot.loader.grub.device = lib.mkDefault "/dev/vda";
  boot.loader.timeout = 1;

  system.build.qcow2 = import <nixpkgs/nixos/lib/make-disk-image.nix> {
    inherit lib config pkgs;
    diskSize = 10240;
    format = "qcow2";
    partitionTableType = "hybrid";
  };
}
{ config, lib, pkgs, ... }: 
{

  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  #nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["console=ttyS0"];
  boot.loader.grub.device = lib.mkDefault "/dev/vda";
  boot.loader.timeout = 1;

  system.stateVersion = "24.05";

  # disable ipv6
	networking.enableIPv6  = false;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  # services.getty.autologinUser = "salverius";
  security.sudo.wheelNeedsPassword = false;

  users = {
    defaultUserShell = pkgs.zsh;
    users.salverius = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "users" ];
      shell = pkgs.zsh;
      password = "";
    };
  };

  system.userActivationScripts.zshrc = "touch .zshrc";

  programs = {
		# needed for vscode remote ssh
		nix-ld.enable = true; 
  };
  
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };

  environment.shells = [ pkgs.zsh ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = false;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ipa  = "ip -br -c a";
      ipn  = "ip -c n";
      l    = "ls -lhA --color=auto --group-directories-first";
      dps  = ''docker ps --format="table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.State}}\t{{.Status}}"'';
      dpsp = ''docker ps --format="table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.State}}\t{{.Status}}\t{{.Ports}}"'';
      nix-gc = "nix-store --gc";
      nix-rs = "sudo nixos-rebuild switch";
      nix-code = "code /etc/nixos/configuration.nix";
      sdn     = "sudo shutdown -h now";
    };
  };

}
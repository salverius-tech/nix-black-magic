{ config, lib, pkgs, ... }: 
{
  system.stateVersion = "23.11";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # disable ipv6
	networking.enableIPv6  = false;

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

  #nixpkgs.config.allowUnfree = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.ilude = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "users" ];
      shell = pkgs.zsh;
      password = "";
    };
  };

  services.getty.autologinUser = "ilude";

  system.userActivationScripts = {
    createZshrcFile = {
      text = ''
        if [ ! -f "$HOME/.zshrc" ]; then
          touch "$HOME/.zshrc"
        fi
      '';
    };
  };

  programs = {
		# needed for vscode remote ssh
		nix-ld.enable = true; 
  };
  
  environment.shells = [ pkgs.zsh ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = false;
    syntaxHighlighting.enable = true;
    shellAliases = {
      l    = "ls -alh";
      ll   = "ls -l";
      ls   = "ls --color=tty";
      dps  = ''docker ps --format="table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.State}}\t{{.Status}}"'';
      dpsp = ''docker ps --format="table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.State}}\t{{.Status}}\t{{.Ports}}"'';
      nix-gc = "nix-store --gc";
      nix-rs = "sudo nixos-rebuild switch";
      nix-code = "code /etc/nixos/configuration.nix";
      sdn     = "sudo shutdown -h now";
    };
  };

  
  security.sudo.wheelNeedsPassword = false;

  environment = {
    systemPackages = with pkgs; [
      python310
      zsh
      zsh-fzf-tab
      zsh-completions
      zsh-autosuggestions
      nix-zsh-completions
      zsh-syntax-highlighting
    ];
  };
}
{ config, lib, pkgs, ... }: 
{
  system.stateVersion = "23.11";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # disable ipv6
	networking.enableIPv6  = false;

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
	 	zsh = {
			enable = true;
			autosuggestions.enable = true;
			zsh-autoenv.enable = false;
			syntaxHighlighting.enable = true;
	  };
  };
  
  security.sudo.wheelNeedsPassword = false;

  environment = {
    shells = [ pkgs.zsh pkgs.bash ];
    shellAliases = {
      l       = "ls -lhA --color=auto --group-directories-first";
      nix-gc  = "nix-store --gc";
      nix-rs  = "sudo nixos-rebuild switch";
      sdn     = "sudo shutdown -h now";
    };
    systemPackages = with pkgs; [
      python310
    ];
  };
}
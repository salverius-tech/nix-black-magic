{ config, lib, pkgs, ... }: 
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  users.users = {
    ilude = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "";
    };
  };

  nixpkgs.config.allowUnfree = true;

	security.sudo.wheelNeedsPassword = false;

	# disable ipv6
	networking.enableIPv6  = false;

  environment.systemPackages = with pkgs; [
    python310
  ];

  system.stateVersion = "23.11";
}
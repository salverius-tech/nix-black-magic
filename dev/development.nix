{ config, lib, pkgs, ... }: 

let

  username = pkgs.lib.removeSuffix "/n" (builtins.getEnv "USERNAME");
  password = pkgs.lib.removeSuffix "/n" (builtins.getEnv "PASSWORD");

in
{
  boot.loader.timeout = 1;

  # services.getty.autologinUser = "salverius";

  users.users.salverius.password = "";


  users.users."${username}" = {
    isNormalUser = true;
    name = username;
    password = password;
    extraGroups = [ "wheel" "docker" "users" ];
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = [
    #   "$(grep SSH_KEY ${doppler-secrets} | cut -d '=' -f2)"
    # ];
  };

}
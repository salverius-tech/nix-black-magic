{ config, lib, pkgs, ... }: 

let

  username = pkgs.lib.removeSuffix "/n" (builtins.getEnv "USERNAME");
  password = pkgs.lib.removeSuffix "/n" (builtins.getEnv "PASSWORD");

in
{

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
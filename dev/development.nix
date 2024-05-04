{ config, lib, pkgs, ... }: 
{
  boot.loader.timeout = 1;

  services.getty.autologinUser = "salverius";

  users.users.salverius.password = "";
}
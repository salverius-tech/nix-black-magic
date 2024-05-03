{ config, lib, pkgs, ... }: 
{
  boot.loader.timeout = 1;

  services.getty.autologinUser = "ilude";

  users.users.ilude.password = "";
}
{ config, lib, pkgs, ... }: 
{

  environment = {
    systemPackages = with pkgs; [
      doppler
      git
      gnumake
      just
      python310
      ssh-import-id
      starship
      zsh
      zsh-fzf-tab
      zsh-completions
      zsh-autosuggestions
      nix-zsh-completions
      zsh-syntax-highlighting
    ];
  };

}
{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rampion";
  home.homeDirectory = "/home/rampion";

  # Packages to install
  home.packages = [
    # pkgs is the set of all packages  in the default home.nix
    # implementation
    pkgs.git
    pkgs.vim
  ];

  # Raw configuration files
  home.file.".gitconfig".source = ./gitconfig;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}

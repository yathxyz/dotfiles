{ pkgs, config, defaultName, ... }:

{
  home.username = defaultName;
  home.homeDirectory = "/home/${defaultName}";

  nixpkgs.config.allowUnfree = true;
}

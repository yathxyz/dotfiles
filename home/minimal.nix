{ inputs, config, pkgs, ... }:

{
  home.username = "yanni";
  home.homeDirectory = "/home/yanni";

  home.file = {
    ".gnupg/common.conf".text = "use-keyboxd";
    ".gnupg/gpg.conf".text = ''
      use-agent
      pinentry-mode loopback
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    gcc
    ripgrep
    fd
    fzf
    make
    unzip
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion =
    "23.05"; # Check home manager release notes before updating
}


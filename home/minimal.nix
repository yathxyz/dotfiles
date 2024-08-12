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
    cargo
    fd
    fzf
    gcc
    gnumake
    python3
    ripgrep
    shell-gpt
    unzip
  ];

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;

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


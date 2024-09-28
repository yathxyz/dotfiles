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
    tmux.enableShellIntegration = true;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    clock24 = true;
    sensibleOnTop = true;
    tmuxp.enable = true;
  };

  home.packages = with pkgs; [
    cargo
    distrobox
    dive
    fd
    gcc
    gh
    gnumake
    podman-compose
    podman-tui
    python3
    ripgrep
    shell-gpt
    tmux
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


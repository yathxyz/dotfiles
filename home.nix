{ config, pkgs, ... }:

{
  home.username = "yanni";
  home.homeDirectory = "/home/yanni";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    brave
    busybox
    discord
    emacs
    feh
    gnupg
    gnuplot
    godot_4
    htop
    libreoffice-fresh
    libsForQt5.okular
    mpv
    nixfmt
    notmuch
    pinentry
    pulseaudio
    python3
    rclone
    signal-desktop
    steam
    telegram-desktop
    tmux
    yt-dlp
    zotero
  ];

  xsession.enable = true;
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.file = {

    ".gnupg/gpg.conf".text = ''
      use-agent
      pinentry-mode loopback
      '';
  };

  home.sessionVariables = rec {
    # EDITOR = "emacs";
    #
    WORKDIR = "$HOME/work/";
    ZOTERODIR = "$HOME/Zotero/";
    STUFFDIR = "$HOME/stuff/";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  programs.terminator.enable = true;
  programs.neovim.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.05"; # Check home manager release notes before updating
}

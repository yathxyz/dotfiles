{ config, pkgs, ... }:

{
  home.username = "yanni";
  home.homeDirectory = "/home/yanni";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    brave
    busybox
    discord
    dconf
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

  #programs.dconf.enable = true;

  qt.enable = true;
  qt.platformTheme = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

  gtk = {
    enable = true;
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";

    #iconTheme.package = pkgs.gruvboxPlus;
    #iconTheme.name = "GruvboxPlus";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.05"; # Check home manager release notes before updating
}

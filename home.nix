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
    xorg.xset
    zotero
  ];

  xsession = {
    enable = true;
    initExtra = ''xset r rate 200 55'';
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.dunst = {
    enable = true;
  };

  home.file = {
    ".gnupg/gpg.conf".text = ''
      use-agent
      pinentry-mode loopback
      '';
  };

  home.sessionVariables = rec {
    WORKDIR = "$HOME/work/";
    ZOTERODIR = "$HOME/Zotero/";
    STUFFDIR = "$HOME/stuff/";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  programs.terminator.enable = true;
  # TODO further configure the emacs module

  programs.emacs.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    defaultEditor = true;
  };

  #programs.dconf.enable = true;

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  gtk = {
    enable = true;
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";

    # icky solution - maybe I could just tell gtk4 to just listen to gtk3 or
    # something
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.05"; # Check home manager release notes before updating
}

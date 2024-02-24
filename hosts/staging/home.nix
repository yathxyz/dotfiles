{ pkgs, config, ... }:

{
  home.username = "yanni";
  home.homeDirectory = "/home/yanni";

  nixpkgs.config.allowUnfree = true;

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  home.packages = with pkgs; [
    autorandr
    awscli2
    brave
    brightnessctl
    ccls
    coreutils-full
    dconf
    discord
    feh
    gdb
    gnupg
    gnuplot
    godot_4
    helix
    htop
    ispell
    isync
    languagetool
    libnotify
    libreoffice-fresh
    libsForQt5.okular
    mpv
    nixfmt
    nodejs_20
    pinentry
    pulseaudio
    rclone
    signal-desktop
    sops
    steam
    tmux
    xclip
    xorg.xset
    yt-dlp
    zotero
  ];

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.dunst.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            ffmpeg-full
            cups
            fluidsynth
            gtk3
            pango
            cairo
            atk
            zlib
            glib
            gdk-pixbuf
          ];
        extraArgs = "-console";
        extraEnv.ROBUST_SOUNDFONT_OVERRIDE =
          "${prev.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
      };

    })
  ];

  home.file = {
    ".gnupg/gpg.conf".text = ''
      use-agent
      pinentry-mode loopback
    '';
    ".config/i3/config".text = builtins.readFile ../../config/i3/config;
    ".Xresources".text = "Xcursor.theme: Bibata-Modern-Ice";
    ".config/helix/config.toml".text =
      builtins.readFile ../../config/helix/config.toml;
    ".config/helix/languages.toml".text =
      builtins.readFile ../../config/helix/languages.toml;
    ".ideavimrc".text = builtins.readFile ../../config/rider/ideavimrc;
    ".config/i3status/config".text =
      builtins.readFile ../../config/i3status/config;
  };

  home.sessionVariables = rec {
    WORKDIR = "$HOME/work/";
    ZOTERODIR = "$HOME/Zotero/";
    STUFFDIR = "$HOME/stuff/";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    EDITOR = "nvim";
  };

  gtk = {
    enable = true;
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";

    # icky solution - maybe I could just tell gtk4 to just listen to gtk3 or
    # something
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };

    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

  programs.kitty = {
    enable = true;
    theme = "Solarized Dark";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
  };

  home.stateVersion =
    "23.05"; # Check home manager release notes before updating

}

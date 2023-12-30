{ config, pkgs, ... }:

let finalname = "yanni";
in {
  home.username = finalname;
  home.homeDirectory = "/home/${finalname}";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    age
    autorandr
    brave
    ccls
    coreutils-full
    dconf
    discord
    feh
    gdb
    gnupg
    gnuplot
    godot_4
    htop
    ispell
    languagetool
    libreoffice-fresh
    libsForQt5.okular
    mpv
    nixfmt
    nodejs_20
    notmuch
    pinentry
    pulseaudio
    python3
    rclone
    signal-desktop
    sops
    steam
    telegram-desktop
    tmux
    xclip
    xorg.xset
    xp-pen-deco-01-v2-driver
    yt-dlp
    zotero
  ];

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.dunst.enable = true;

  home.file = {
    ".gnupg/gpg.conf".text = ''
      use-agent
      pinentry-mode loopback
    '';
    ".config/i3/config".text = builtins.readFile ./config/i3/config;
    ".Xresources".text = "Xcursor.theme: Bibata-Modern-Ice";
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

  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
  };

  # TODO further configure the emacs module

  programs.emacs.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      rr =
        "curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | ${pkgs.bash}/bin/bash";
    };

    oh-my-zsh = {
      enable = true;
      theme = "bira";
      plugins = [ "git" "sudo" ];
      extraConfig = "${pkgs.pfetch}/bin/pfetch";
    };
  };

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
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };

    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion =
    "23.05"; # Check home manager release notes before updating
}

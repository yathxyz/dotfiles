{ inputs, config, pkgs, ... }:

{

  home.username = "yanni";
  home.homeDirectory = "/home/yanni";

  home.packages = with pkgs; [
    awscli2
    dconf
    fd
    emacs
    gnupg
    ispell
    isync
    languagetool
    libnotify
    mpv
    nixfmt-classic
    pinentry
    pulseaudio
    rclone
    ripgrep
    signal-desktop
    sops
    tmux
    xclip
    xorg.xset
    yt-dlp
    zotero
  ];

  home.file = {
    ".gnupg/gpg.conf".text = ''
      use-agent
      pinentry-mode loopback
    '';
    ".config/i3/config".text = builtins.readFile ./config/i3/config;
    #".Xresources".text = "Xcursor.theme: Bibata-Modern-Ice";
    ".ideavimrc".text = builtins.readFile ./config/rider/ideavimrc;
    ".config/i3status/config".text = builtins.readFile ./config/i3status/config;
    #".config/emacs/init.el".text = builtins.readFile ./config/emacs/init.el;
    ".config/nvim/init.lua".text = builtins.readFile ./config/nvim/init.lua;
  };

  #  home.sessionVariables = rec {
  #    WORKDIR = "$HOME/work/";
  #    ZOTERODIR = "$HOME/Zotero/";
  #    STUFFDIR = "$HOME/stuff/";
  #    XDG_CACHE_HOME = "$HOME/.cache";
  #    XDG_CONFIG_HOME = "$HOME/.config";
  #    XDG_DATA_HOME = "$HOME/.local/share";
  #    XDG_STATE_HOME = "$HOME/.local/state";
  #    EDITOR = "nvim";
  #  };

  programs.firefox.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion =
    "23.05"; # Check home manager release notes before updating

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

}

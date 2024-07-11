{ inputs, config, pkgs, ... }:

{
  home.username = "yanni";
  home.homeDirectory = "/home/yanni";

  home.file = {
    ".gnupg/gpg.conf".text = ''
      use-agent
      pinentry-mode loopback
    '';
    ".config/i3/config".text = builtins.readFile ./config/i3/config;
    #".Xresources".text = "Xcursor.theme: Bibata-Modern-Ice";
    ".ideavimrc".text = builtins.readFile ./config/rider/ideavimrc;
    ".config/i3status/config".text = builtins.readFile ./config/i3status/config;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.theme = "cloud";

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion =
    "23.05"; # Check home manager release notes before updating
}

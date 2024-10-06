{ pkgs, lib, config, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  documentation.dev.enable = true;

  services.pcscd.enable = true; # Required for yubikey setup

  programs.nix-ld.enable = true;

  programs.direnv.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Set up complementary lisp machine
  # nixpkgs.overlays = [ emacs-overlay.overlay ];

  #  services.emacs = {
  #    enable = true;
  #    package = pkgs.emacsWithPackagesFromUsePackage {
  #      package = pkgs.emacs;
  #      config = ../home/config/emacs/init.el;
  #    };
  #  };

  # TODO please make this actually reproducible
  services.syncthing = {
    enable = true;
    user = "yanni";
    configDir = "/home/yanni/.config/syncthing/";
  };

  # Time and locale stuff

  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Favourite shell
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.theme = "cloud";
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Nix helper
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };

}

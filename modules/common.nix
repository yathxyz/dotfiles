{ pkgs, lib, config, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  documentation = {
    enable = true;
    dev.enable = true;
    nixos.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };

    info.enable = true;
    doc.enable = true;
  };

  environment.systemPackages = with pkgs; [
    linux-manual
    man-pages
    man-pages-posix
  ];

  services.pcscd.enable = true; # Required for yubikey setup

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.nix-ld.enable = true;

  programs.direnv.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.wireshark.enable = true;

  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
    };
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
    ohMyZsh.theme = "crunch";
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

  # Some environment variables
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    WORKDIR = "$HOME/work";
    ZOTERODIR = "$HOME/Zotero";

    EDITOR = "nvim";

    # Not officially in the specification
    XDG_BIN_HOME    = "$HOME/.local/bin";

    # TODO You might want to remove this eventually
    # You can just use the nix store. Obviously.
    MASON_BIN_HOME  = "$XDG_DATA_HOME/nvim/mason/bin";
    PATH = [
      "${XDG_BIN_HOME}"
      "${MASON_BIN_HOME}"
    ];
  };

}

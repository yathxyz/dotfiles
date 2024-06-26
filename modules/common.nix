{ inputs, pkgs, lib, config, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # Set up complementary lisp machine
  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

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

}

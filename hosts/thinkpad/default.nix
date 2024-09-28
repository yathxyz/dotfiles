{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJuFsupm/NByu90P+nUwFKA38N7zlgn9AJFr593WSra root@thinkpad";

  boot.loader.efi.canTouchEfiVariables = true;

  boot = { kernelPackages = pkgs.linuxPackages_latest; };

  # TODO Setup keyfile
  # boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  # Networking
  networking.hostName = "thinkpad";
  networking.hosts = { "192.168.0.10" = [ "home.local" "grapes.local" ]; };

  services.openssh.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ ];
  networking.networkmanager.enable = true;
  environment.pathsToLink = [ "/libexec" ];

  services = {

    displayManager = {
      autoLogin = { enable = true; user = "yanni"; };
    };

    xserver.windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock ];
    };
  };

  services.dbus.enable = true;

  services.xserver.xkb.layout = "us,gr";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Bluetooth settings
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # security.pam.services = {
  #   login.u2fAuth = true;
  #   sudo.u2fAuth = true;
  # };

  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.yanni = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Ioannis Eleftheriou";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    coreutils-full
    curl
    distrobox
    feh
    git
    gnupg-pkcs11-scd
    htop
    libtool
    neovim
    nh
    pcsclite
    perl
    ripgrep
    sqlite
    wget
  ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    # For nh
    FLAKEREF = "$HOME/proj/dotfiles";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    EDITOR = "nvim";
    WORKDIR = "$HOME/work/";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

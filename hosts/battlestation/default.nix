{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #      inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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


  age.identityPaths = [ "/home/yanni/.ssh/id_ed25519" ];
  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  ## Run unpatched dynamic libraries on NixOS
  programs.nix-ld.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  #  home-manager = {
  #    extraSpecialArgs = { inherit inputs; };
  #    users = { 
  #      "yanni" = {
  #        home.sessionVariables = {
  #	  WORKDIR = "$HOME/work/";
  #	  ZOTERODIR = "$HOME/Zotero/";
  #	  STUFFDIR = "$HOME/stuff/";
  #	  EDITOR = "nvim";
  #
  #        };
  #
  #	home.stateVersion = "23.05";
  #      };
  #    };
  #  };

  virtualisation.docker.enable = true;

  networking.hostName = "battlestation"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Nvidia proprietary drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  hardware.graphics.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.desktop.background]
      picture-options='none'
      primary-color='#000000'
    '';
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yanni = {
    isNormalUser = true;
    description = "Ioannis Eleftheriou";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      signal-desktop
      #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.enable = true;
  services.xserver.displayManager.autoLogin.user = "yanni";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    cargo
    emacs
    fd
    gcc
    git
    gnumake
    neovim
    ripgrep
    unzip
    xclip
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "emacs";

    WORKDIR = "$HOME/work/";
    ZOTERODIR = "$HOME/Zotero/";
    STUFFDIR = "$HOME/stuff/";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.flatpak.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11"; # Did you read the comment?

}

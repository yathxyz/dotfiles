{ config, pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports = [ ./vpsadminos.nix ];

  age.identityPaths = [ "/home/yanni/.ssh/id_ed25519" ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    wget
    gnupg
    emacs
    comic-mono
    gcc
    podman-tui
    dive
    podman-compose
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  networking.hostName = "spacestation-libra";
  services.openssh = {
    enable = true;
    ports = [ 443 ]; # It's called we do a little trolling
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  users.users.yanni = {
    isNormalUser = true;
    home = "/home/yanni";
    description = "Ioannis Eleftheriou";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKfnFPjYTtZPryU30vnTLkJU3hQSMDUMKFi/Gv23lTC3"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK57s5sR1Kfqr6K6dCMJRo2NU0F9OeLrF//sOrlDSd2R"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHQ3V/Ikc3SPoP1ypRvGlcQoEbRlfqdIhHg+vMWFGRj"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILGzEe3dRqGrgQ09vftWsg1bNPpmINACCEmHoPBMHvwfAAAABHNzaDo= 843-personal"
    ];
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  environment.sessionVariables = {
    WORKDIR = "$HOME/work/";
    EDITOR = "nvim";
  };
  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Dublin";

  system.stateVersion = "24.05";
}

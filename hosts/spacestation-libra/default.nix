{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  imports = [ ./vpsadminos.nix ];

  age.identityPaths = [ "/home/yanni/.ssh/id_ed25519" ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
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

  security.acme = {
    acceptTerms = true;
    defaults.email = "me@yath.xyz";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    # other Nginx options
    virtualHosts."spacestation-libra.yath.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/test" = {
        proxyPass = "http://127.0.0.1:8081/";
        proxyWebsockets = true;
      };
      locations."/tty" = {
        proxyPass = "http://127.0.0.1:8080/";
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header Host $host;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
        '';
      };
    };
  };

  services.ttyd = {
    writeable = true;
    enable = true;
    entrypoint = [ "${pkgs.tmux}/bin/tmux" ];
    user = "yanni";
    username = "yathxyz";
    port = 8080;
    passwordFile = config.age.secrets.secret1.path;
    maxClients = 1;
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

{ config, pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports = [ ./vpsadminos.nix ];

  services.syncthing = {
    user = "yanni";
    enable = true;
    configDir = "/home/yanni/.config/syncthing";
  };

  age.identityPaths = ["/home/yanni/.ssh/id_ed25519"];


  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };
  environment.systemPackages = with pkgs; [ neovim git curl wget gnupg emacs comic-mono gcc ];

  virtualisation.podman.enable = true;

  networking.hostName = "spacestation-libra";
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;

  users.users.yanni = {
    isNormalUser = true;
    home = "/home/yanni";
    description = "Ioannis Eleftheriou";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKfnFPjYTtZPryU30vnTLkJU3hQSMDUMKFi/Gv23lTC3"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK57s5sR1Kfqr6K6dCMJRo2NU0F9OeLrF//sOrlDSd2R"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHQ3V/Ikc3SPoP1ypRvGlcQoEbRlfqdIhHg+vMWFGRj"
    ];
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;
    oh-my-zsh.theme = "cloud";
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
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

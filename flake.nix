{
  description = "Flake for opinionated digital work environments";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Would like to use it but I can't build things from source just yet
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, agenix, agenix-rekey, ... }@inputs:
    let
      defaultName = "yanni";
      system = "x86_64-linux"; # We are making a very bad assumption here
      pkgs = nixpkgs.legacyPackages.${system};

      commonModules = [
        ./modules/common.nix
        ./modules/fonts.nix
        ./secrets
        agenix.nixosModules.default
        agenix-rekey.nixosModules.default
      ];

    in {
      overlays.steamOverlay = (final: prev: {
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
  };});
      overlays.emacs = emacs-overlay.overlays.default;

      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nodes = self.nixosConfigurations;
      };

      nixosConfigurations = {

        battlestation = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./hosts/battlestation
            ./modules/desktops.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yanni = import ./home/minimal.nix;
            }
          ];
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./hosts/thinkpad
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yanni = import ./home/laptop.nix;
            }
          ];
        };

        spacestation-libra = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./hosts/spacestation-libra
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yanni = import ./home/minimal.nix;
            }
          ];
        };

        deck = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ({ nixpkgs.overlays = [
              self.overlays.emacs
              self.overlays.steamOverlay
            ]; })
            ./hosts/deck
            ./modules/desktops.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yanni = import ./home/minimal.nix;
            }
          ];
        };
      };

      homeConfigurations = {
        ${defaultName} = home-manager.lib.homeManagerConfiguration {

          inherit pkgs;

          modules = [ ./home/minimal.nix ];
          extraSpecialArgs = {
            inherit inputs;
            inherit defaultName;
          };
        };
      };
    };
}

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

  outputs = { self, nixpkgs, home-manager, emacs-overlay, agenix, ... }@inputs:
    let
      defaultName = "yanni";
      system = "x86_64-linux"; # We are making a very bad assumption here
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = import ./overlays.nix;
    in {
      overlays.steamOverlay = overlays.steamOverlay;

      nixosConfigurations = {
        battlestation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ 
            ./hosts/battlestation 
            ./secrets
            agenix.nixosModules.default
          ];
        };

        surface = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/surface ];
        };

        grapes = nixpkgs.lib.nixosSystem { # Raspberry pi
          system = "aarch64-linux";
          modules = [ ./hosts/grapes ];
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/common.nix
            ./hosts/thinkpad
            ./modules/fonts.nix
            ./secrets
            agenix.nixosModules.default
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
	  modules = [
	    ./hosts/spacestation-libra
            ./secrets
            agenix.nixosModules.default
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
          modules = [
            ./hosts/deck
            ./modules/common.nix
            ./modules/fonts.nix
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

      # Very hacky and absolutely disgusting but I need this for the time being
      # Otherwise I can't risk being stuck in a situation where I can't rekey
      # my secrets properly.
      # That *probably* means that I can only set up secrets when using x86_64-linux.
      # Great!
      devShells.${system}.secrets = let
        pkgs = import nixpkgs { system = "x86_64-linux"; overlays = [ inputs.agenix-rekey.overlays.default ]; };
    in pkgs.mkShell { packages = [ pkgs.agenix-rekey ];}; 
    };
}

{
  description = "Flake for opinionated digital work environments";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      defaultName = "yanni";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = import ./overlays.nix;
    in {
      overlays.steamOverlay = overlays.steamOverlay;
      nixosConfigurations = {
        battlestation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/battlestation ];
        };

        staging = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/staging ];
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
          modules = [
            ./hosts/thinkpad
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yanni = import ./home/laptop.nix;
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

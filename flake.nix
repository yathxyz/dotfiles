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
    in {
      nixosConfigurations = {
        battlestation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/battlestation ];
        };

        staging = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ 
	    ./hosts/staging 
	  ];
        };

        surface = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/surface ];
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/thinkpad ];
        };
      };

      homeConfigurations = {
        ${defaultName} = home-manager.lib.homeManagerConfiguration {

          inherit pkgs;

          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            inherit defaultName;
          };
        };
      };
    };
}

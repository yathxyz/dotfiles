{
  description = "Flake for opinionated digital work environments";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { nixpkgs, home-manager, nix-colors, ... }@inputs:
    let
      # TODO make this ISA agnostic - it should work for now
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      finalname = "yanni";
    in {
      nixosConfigurations = {
        battlestation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/battlestation ];
        };

        surface = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/surface ];
        };
      };
      homeConfigurations = {
        ${finalname} = home-manager.lib.homeManagerConfiguration {

          inherit pkgs;

          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit nix-colors; };
        };
      };
    };
}

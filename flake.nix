{
  description = "home manager configuration for dotfiles";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { nixpkgs, home-manager, nix-colors, ... }:
    let
      # TODO make this ISA agnostic - it should work for now
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      finalname = "yanni";
    in {
      homeConfigurations = {
        ${finalname} = home-manager.lib.homeManagerConfiguration {

          inherit pkgs;

          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit nix-colors; };
        };
      };
    };
}

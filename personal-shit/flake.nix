{
  description = "testing flakes, specifically in regards to making more modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosModules.personal-shit = import ./stuff.nix;
      nixosModules.default = self.nixosModules.personal-shit;
  };
}

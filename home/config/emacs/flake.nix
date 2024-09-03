{
  description = "Flake for Emacs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, emacs-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ emacs-overlay.overlay ];
        };

        emacsWithPlugins = pkgs.emacsWithPackages (epkgs: [
          epkgs.evil
          epkgs.magit
          # Add more Emacs plugins here
        ]);
      in {
        packages = { emacs = emacsWithPlugins; };

        defaultPackage = self.packages.${system}.emacs;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              emacsWithPlugins
              # Add other development dependencies here
            ];
        };
      });
}


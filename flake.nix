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
      pkgs = nixpkgs.legacyPackages.${system}.extend (final: prev:
        let dataDir = "var/lib/xppend1v2";
        in {
          xp-pen-deco-01-v2-driver = prev.xp-pen-deco-01-v2-driver.overrideAttrs
            (oldAttrs: rec {
              version = "3.4.9-231023";

              src = prev.fetchzip {
                url =
                  "https://www.xp-pen.com/download/file/id/1936/pid/440/ext/gz.html#.tar.gz";
                name = "xp-pen-deco-01-v2-driver-${version}.tar.gz";
                sha256 = "sha256-A/dv6DpelH0NHjlGj32tKv37S+9q3F8cYByiYlMuqLg=";
              };
              installPhase = ''
                runHook preInstall

                mkdir -p $out/{opt,bin}
                cp -r App/usr/lib/pentablet/{PenTablet,resource.rcc,conf} $out/opt
                chmod +x $out/opt/PenTablet
                cp -r App/lib $out/lib
                sed -i 's#usr/lib/pentablet#${dataDir}#g' $out/opt/PenTablet

                runHook postInstall

              '';
              postFixup = ''
                makeWrapper $out/opt/PenTablet $out/bin/xp-pen-deco-01-v2-driver \
                  "''${qtWrapperArgs[@]}" \
                  --run 'if [ "$EUID" -ne 0 ]; then echo "Please run as root."; exit 1; fi' \
                  --run 'if [ ! -d /${dataDir} ]; then mkdir -p /${dataDir}; cp -r '$out'/opt/conf /${dataDir}; chmod u+w -R /${dataDir}; fi'
              '';
            });
        });
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

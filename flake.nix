{
  description = "deej is an Arduino & Go project to let you build your own hardware mixer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    perSystem = { config, self', inputs', pkgs, system, ... }: {
      packages = {
        deej = pkgs.buildGoModule {
          pname = "deej";
          version = "0.9.10";

          src = pkgs.fetchFromGitHub {
            owner = "omriharel";
            repo = "deej";
            rev = "9c0307b96341538ec46f18d2e9b18aaa84441175";
            hash = "sha256-ztaVbWQiX59gPlrtvxNqJGqpMYApOKwIUvE4lS/sWVw="; # Placeholder, to be replaced with actual hash
            };

          vendorHash = "sha256-1gjFPD7YV2MTp+kyC+hsj+NThmYG3hlt6AlOzXmEKyA="; # Placeholder, to be replaced with actual hash

          patches = [
            ./config.go.patch
            ./deej.go.patch
            ./main.go.patch
            ./tray.go.patch
          ];

          nativeBuildInputs = with pkgs; [ pkg-config ];

          propagatedBuildInputs = with pkgs; [ 
            gtk3
            libappindicator-gtk3
            webkitgtk
          ];

          postFixup = ''
            mv $out/bin/cmd $out/bin/deej
          '';

          meta = let
              lib = pkgs.lib;
            in {
              description = "Daemon for controlling volume levels with usb serial";
              homepage = "https://github.com/omriharel/deej";
              license = lib.licenses.mit;
              maintainers = with lib.maintainers; [ bndlfm ];
            };
        };
        default = config.packages.deej;
      };
    };
  };
}

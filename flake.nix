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
            owner = "bndlfm";
            repo = "deejus";
            rev = "90f6da8008277bc004f6fb194c088595b76e5111";
            hash = "sha256-e3qR3e8cbC/6iArObN9V3RZPceTq1597b/fQZskeKUE=";
            };

          vendorHash = "sha256-1gjFPD7YV2MTp+kyC+hsj+NThmYG3hlt6AlOzXmEKyA=";

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

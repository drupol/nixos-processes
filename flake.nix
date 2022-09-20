{
  description = "NixOS Processes";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem allSystems (system:
      let
        version = self.shortRev or self.lastModifiedDate;

        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        packages = [
          pkgs.plantuml
          pkgs.jetbrains.phpstorm
        ];

      in {
        # Nix shell / nix build
        packages = {
          default = pkgs.buildEnv {
            name = "devshell";
            paths = packages;
          };
        };

        # Nix develop
        devShells = {
          default = pkgs.mkShellNoCC {
            name = "devshell";
            buildInputs = packages;
          };
        };
      }
    );
}

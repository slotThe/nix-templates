{
  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs = {
        nixpkgs.follows     = "nixpkgs";
        systems.follows     = "systems";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}.extend poetry2nix.overlays.default;
          python = pkgs.python312;
      in {
        packages = {
          inherit python;
          main = pkgs.mkPoetryApplication { projectDir = self; };
          default = self.packages.${system}.main;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.main ];
          packages   = [ pkgs.poetry ];
          nativeBuildInputs = [ pkgs.nodejs_22 python ];
          shellHook = ''
            export PROJECT_ROOT="$(pwd)"
          '';
        };
      });
}

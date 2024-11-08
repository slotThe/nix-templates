{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem flake-utils.lib.allSystems (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        # nix develop
        devShells.default =
          pkgs.mkShell {
            buildInputs = with pkgs; [
              texlive.combined.scheme-full
            ];
          };
        packages = {
          main = pkgs.stdenvNoCC.mkDerivation rec {
            name = throw "Enter a project name";
            src = self;
            buildInputs = with pkgs; [
              coreutils
              texlive.combined.scheme-full
            ];
            phases = ["unpackPhase" "buildPhase" "installPhase"];
            type = "git";
            buildPhase = ''
              export PATH="${pkgs.lib.makeBinPath buildInputs}";
              mkdir -p .cache/texmf-var
              env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              latexmk -interaction=nonstopmode -pdf -shell-escape \
              main
            '';
            installPhase = ''
              mkdir -p $out
              cp main.pdf $out/
            '';
          };
        };
        defaultPackage = packages.main;
      });
}

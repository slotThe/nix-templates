{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      package = throw "Enter a name for your package!";
      system  = "x86_64-linux";
      pkgs    = nixpkgs.legacyPackages.${system};
      overlay = final: prev: {
        main = prev.callCabal2nix package ./. { };
        haskell-aoc-util  = prev.callCabal2nix "haskell-aoc-util" ../../util/haskell-aoc-util { };
      };
      haskellPackages = pkgs.haskellPackages.extend overlay;
    in {
      # nix build
      packages.${system}.default = haskellPackages.main;

      # nix develop
      devShells.${system}.default = haskellPackages.shellFor {
        packages = p: [ p.main ];
        buildInputs = with haskellPackages; [
          cabal-install
          haskell-language-server
          hpack
        ];
      };
    };
}

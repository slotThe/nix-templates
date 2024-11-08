{
  outputs = { self }: {

    templates = {
      python = {
        path = ./python;
        description = "Poetry2nix template";
      };
      rust = {
        path = ./rust;
        description = "Rust-overlay template for nightly";
      };
      haskell = {
        path = ./haskell;
        description = "CallCabal2nix template";
      };
      ocaml = {
        path = ./ocaml;
        description = "Opam-nix template";
      };
      latex = {
        path = ./latex;
        description = "LaTeX template";
      };
    };

    defaultTemplate = self.templates.haskell;
  };
}

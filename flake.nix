{
  outputs = { self }: {

    templates = {
      python  = { path=./python ; description="Python template" ; };
      rust    = { path=./rust   ; description="Rust template"   ; };
      haskell = { path=./haskell; description="Haskell template"; };
      ocaml   = { path=./ocaml  ; description="Ocaml template"  ; };
      latex   = { path=./latex  ; description="LaTeX template"  ; };
      bqn     = { path=./bqn    ; description="BQN template"    ; };
      clojure = { path=./clojure; description="Clojure template"; };
    };

    defaultTemplate = self.templates.haskell;
  };
}

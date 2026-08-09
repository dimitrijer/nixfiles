let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    overlays = [ ];
  };
  nixfiles = import ./default.nix { };
  neovim = nixfiles.neovim {
    inherit pkgs;
    withHaskell = true;
    withOCaml = true;
  };
  python3 = nixfiles.python3 { inherit pkgs; };
  tmux = nixfiles.tmux { inherit pkgs; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # For vim-codefmt.
    nixpkgs-fmt
    ormolu
    ocamlformat
  ] ++ [
    neovim
    python3
    tmux
  ];
}

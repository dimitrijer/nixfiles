let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { 
    overlays = [];
    config = {};
  };
  nixfiles = import ./default.nix { };
  neovim = nixfiles.neovim {
    pkgs = pkgs;
    withHaskell = true;
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # For vim-codefmt.
    ormolu
  ] ++ [ neovim ];
}

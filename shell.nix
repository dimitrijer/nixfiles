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
  powerline-gitstatus = nixfiles.powerline-gitstatus { pkgs = pkgs; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # For vim-codefmt.
    nixpkgs-fmt
    ormolu
  ] ++ [ 
    neovim 
    powerline-gitstatus
  ];
}

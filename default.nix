{}:

{ 
  neovim = import ./neovim/neovim.nix; 
  python3 = import ./python3.nix;
  tmux = import ./tmux/tmux.nix;
}

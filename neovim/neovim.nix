{ pkgs, vimRC ? import ./vimrc, withFzf ? true }:

pkgs.neovim.override {
  configure = {
    customRC = vimRC;

    packages.myPlugins = with pkgs.vimPlugins; {
      start = [
        ### Bare necessities
        nerdtree            # File manager
        syntastic           # Syntax checker
        vim-airline         # Status bar
        vim-surround        # Quick surround (ysiW)
        vim-repeat          # Use . for plugin command repetition, too
        vim-commentary      # Better comments (gc)
        vim-unimpaired      # Bracket mappings ([n, ]n, [c, ]c, etc.)
        rainbow_parentheses # Pretty paren
        vim-highlightedyank # Highlight yanked regions
        vim-conjoin         # Smart line join (J)

        ### Swag
        vim-airline-themes
        base16-vim
        coc-nvim
      ] ++ (if withFzf then [fzf-vim] else []) # Quick search
      ;
    };
  };
}

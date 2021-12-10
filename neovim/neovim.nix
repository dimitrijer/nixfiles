{ pkgs
, withClojure ? false
, withHaskell ? false
, withWriting ? false
, withZettel  ? false
}:

let
  vimRC       = import ./vimrc.nix { withWriting = withWriting; };
  vim-conjoin = pkgs.vimUtils.buildVimPlugin {
    name = "vim-conjoin";
    src = pkgs.fetchFromGitHub {
      owner = "flwyd";
      repo = "vim-conjoin";
      rev = "9f2f76a8845249933ebbea70b3c0bed04e7153ac";
      sha256 = "1k1rd4gck7ifmn91dmj1zcxxkggjxzdn4r4s50g29bky3dp8zjim";
    };
  };
  vim-lambdify = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-lambdify";
    src = pkgs.fetchFromGitHub {
      owner = "calebsmith";
      repo = "vim-lambdify";
      rev = "58686218f0b0410acdb39575e7273147b5d024de";
      sha256 = "1gkwghwbgcwj1f1lxp2gk3vg2zqqigdr1h6p7sl34nzwhklvwpd0";
    };
  };
in pkgs.neovim.override {
  configure = {
    customRC = vimRC;

    packages.myPlugins = with pkgs.vimPlugins; {
      start = [
        ### Bare necessities
        nerdtree            # File manager
        syntastic           # Syntax checker
        coc-nvim            # LSP support
        fzf-vim             # Quick search
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
        vim-devicons        # Pretty icons in NERDtree
        vim-lambdify        # -> <bling> defn -> lambda symbol. </bling>
        vim-signify         # Git diff column

        ### Google
        vim-maktaba         # Google plugin library
        vim-codefmt         # Auto-formatters

        ### Better syntax parsing
        (nvim-treesitter.withPlugins (
         plugins: with plugins; [
           tree-sitter-c
           tree-sitter-java
           tree-sitter-go
           tree-sitter-nix
           # These don't compile on OS X
           # tree-sitter-haskell
           # tree-sitter-plugin
           # tree-sitter-markdown
         ]
        ))
      ]
      ++ (if withClojure then [
        vim-salve      # Lein support
        vim-dispatch   # REPL integration
        vim-fireplace  # Run builds and tests in tmux or screen
        vim-sexp       # Selection and movement for compound forms and elements
                       # (e.g. vaf, vae, vas)
        vim-sexp-mappings-for-regular-people # dsb, csb, cse...
      ] else [])
      ++ (if withHaskell then [haskell-vim] else [])
      ++ (if withWriting then [tabular vim-markdown goyo limelight] else [])
      ++ (if withZettel then [vimwiki vim-zettel] else []);
    };
  };
}

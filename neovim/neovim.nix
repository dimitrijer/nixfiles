{ pkgs ? import <nixpkgs> {}
, withClojure ? false
, withHaskell ? false
, withWriting ? false
, withZettel ? false
, preVimRC ? ""
, postVimRC ? ""
}:

let
  vimRC = preVimRC + import ./vimrc.nix { withWriting = withWriting; } + postVimRC;
  vim-conjoin = pkgs.vimUtils.buildVimPlugin {
    name = "vim-conjoin";
    src = pkgs.fetchFromGitHub {
      owner = "flwyd";
      repo = "vim-conjoin";
      rev = "9f2f76a8845249933ebbea70b3c0bed04e7153ac";
      sha256 = "1k1rd4gck7ifmn91dmj1zcxxkggjxzdn4r4s50g29bky3dp8zjim";
    };
    meta.homepage = "https://github.com/flwyd/vim-conjoin";
  };
  vim-lambdify = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-lambdify";
    src = pkgs.fetchFromGitHub {
      owner = "calebsmith";
      repo = "vim-lambdify";
      rev = "58686218f0b0410acdb39575e7273147b5d024de";
      sha256 = "1gkwghwbgcwj1f1lxp2gk3vg2zqqigdr1h6p7sl34nzwhklvwpd0";
    };
    meta.homepage = "https://github.com/calebsmith/vim-lambdify";
  };
  vim-codefmt = pkgs.vimUtils.buildVimPlugin {
    name = "vim-codefmt";
    src = pkgs.fetchFromGitHub {
      owner = "dimitrijer";
      repo = "vim-codefmt";
      rev = "d71e62da8529dc80e76cfbcfb8ae5d3ff6f8bd6c";
      sha256 = "1dmfkj0cmyxx3q7rrsxlhgiax2w5q82bxvavs0j0j8zhsa6m7a0j";
    };
    meta.homepage = "https://github.com/dimitrijer/vim-codefmt";
  };
  kanagawa-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "kanagawa.nvim";
    version = "2022-03-02";
    src = pkgs.fetchFromGitHub {
      owner = "rebelot";
      repo = "kanagawa.nvim";
      rev = "63cb5cc1a80def7da4bb375adee1587866250a17";
      sha256 = "08iwz314c0k63mwv3yka8n79lb2627nbx9n81l9crz1f3nplaasd";
    };
    meta.homepage = "https://github.com/rebelot/kanagawa.nvim";
  };
  vimPluginsLua = with pkgs.vimPlugins; [
    plenary-nvim
    (nvim-treesitter.withPlugins (
      plugins: with plugins; [
        tree-sitter-c
        tree-sitter-cpp
        tree-sitter-make
        tree-sitter-html
        tree-sitter-css
        tree-sitter-javascript
        tree-sitter-typescript
        tree-sitter-vim
        tree-sitter-java
        tree-sitter-go
        tree-sitter-nix
        # vim-markdown is better at this than TS.
        # tree-sitter-markdown
        tree-sitter-json
        tree-sitter-yaml
        tree-sitter-toml
        tree-sitter-python
        # TS Haskell syntax is too colorful for me at the moment. vim-haskell it is.
        # tree-sitter-haskell
        tree-sitter-clojure
      ]
    ))
    nvim-treesitter-textobjects # More textobjects
    nvim-tree-lua # File explorer
    nvim-web-devicons # Pretty ft icons
    telescope-nvim # Multifunctional searcher
    telescope-fzf-native-nvim # Pure C fzf sorter for telescope
    lualine-nvim # Status line
    lualine-lsp-progress # Show LSP init progress in status line
    neomake # Syntax checker
    gitsigns-nvim # Git diff column

    vim-surround # Quick surround (ysiW)
    vim-repeat # Use . for plugin command repetition, too
    vim-commentary # Better comments (gc)
    vim-unimpaired # Bracket mappings ([n, ]n, [c, ]c, etc.)
    rainbow # Pretty paren
    vim-highlightedyank # Highlight yanked regions
    vim-conjoin # Smart line join (J)
    vim-lambdify # -> <bling> defn -> lambda symbol. </bling>
    vim-maktaba # Google plugin library

    luasnip # Snippet engine
    friendly-snippets # A collection of snippets for various languages

    nvim-lspconfig # Native LSP support
    nvim-cmp # Completion engine
    cmp-nvim-lsp # LSP completion
    cmp-nvim-lua # Have no idea what this is
    cmp-nvim-lsp-document-symbol # Type /@
    cmp_luasnip # Snippet completion
    cmp-path # Path completion
    cmp-buffer # Completion of stuff that's in buffer

    sonokai # Colorscheme
    lsp_signature-nvim # As you type fn arguments get type hints
    symbols-outline-nvim # LSP-powered outline bar
  ];
in
pkgs.neovim.override {
  configure = {
    customRC = vimRC;

    packages.myPlugins = with pkgs.vimPlugins; {
      start = vimPluginsLua
        ++ (if withClojure then [
        vim-salve # Lein support
        vim-dispatch # REPL integration
        vim-fireplace # Run builds and tests in tmux or screen
        vim-sexp # Selection and movement for compound forms and elements
        # (e.g. vaf, vae, vas)
        vim-sexp-mappings-for-regular-people # dsb, csb, cse...
      ] else [ ])
        ++ (if withHaskell then [ haskell-vim ] else [ ])
        ++ (if withWriting then [ tabular vim-markdown goyo-vim limelight-vim ] else [ ])
        # ++ (if withZettel then [ vimwiki vim-zettel ] else [ ])
        ++ [
        # Custom vim-codefmt.
        vim-codefmt
      ];
    };
  };
}

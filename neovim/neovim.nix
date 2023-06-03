{ pkgs ? import <nixpkgs> { }
, withClojure ? false
, withHaskell ? false
, withOCaml ? false
, withWriting ? false
, withZettel ? false
, preVimRC ? ""
, postVimRC ? ""
}:

let
  vimRC = preVimRC + import ./vimrc.nix {
    withWriting = withWriting;
    withHaskell = withHaskell;
    withOCaml = withOCaml;
  } + postVimRC;
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
      owner = "google";
      repo = "vim-codefmt";
      rev = "6ee1e7e22a6ff793331da96c0884f0b906e7dc96";
      sha256 = "116r2hrbf87silgzp5py7chp8wcb64rhxcg5vhscq2gp7080yv7h";
    };
    meta.homepage = "https://github.com/google/vim-codefmt";
  };
  vim-glaive = pkgs.vimUtils.buildVimPlugin {
    name = "vim-glaive";
    src = pkgs.fetchFromGitHub {
      owner = "google";
      repo = "vim-glaive";
      rev = "3c5db8d279f86355914200119e8727a085863fcd";
      hash = "sha256-uNDz2MZrzzRXfVbS5yUGoJwa6DMV63yZXO31fMUrDe8=";
    };
    meta.homepage = "https://github.com/google/vim-glaive";
  };
  kanagawa-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "kanagawa.nvim";
    version = "2022-03-02";
    src = pkgs.fetchFromGitHub {
      owner = "rebelot";
      repo = "kanagawa.nvim";
      rev = "14a7524a8b259296713d4d77ef3c7f4dec501269";
      sha256 = "1d9r29352bi9a4rzhxji1j3vj89swydsayszs621f0917zwpml87";
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
        tree-sitter-ocaml
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
    vim-glaive # Google Maktaba plugin config

    luasnip # Snippet engine
    friendly-snippets # A collection of snippets for various languages

    nvim-lspconfig # Native LSP support
    nvim-cmp # Completion engine
    cmp-nvim-lsp # LSP completion
    cmp_luasnip # Snippet completion
    cmp-buffer # Completion of stuff that's in buffer

    sonokai # Colorscheme
    lsp_signature-nvim # As you type fn arguments get type hints
    symbols-outline-nvim # LSP-powered outline bar
    trouble-nvim # LSP diagnostics
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

{ withWriting ? false
, withHaskell ? false
, withOCaml ? false
}:

''
  " Running in nix, so ignore ~/.vim
  set runtimepath-=~/.vim

  """
  """ Vim filetype-specific config starts here
  """

  " PEP8 indentation
  au BufNewFile,BufRead *.py |
      \ set tabstop=4 |
      \ set softtabstop=4 |
      \ set shiftwidth=4 |
      \ set textwidth=0 |
      \ set wrapmargin=0 |
      \ set expandtab |
      \ set autoindent |
      \ set fileformat=unix |
      \ set textwidth=79

  au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.cpp,*.hpp,*.java match BadWhitespace /\s\+$/

  au Filetype clojure setlocal textwidth=80
  au Filetype c,h,cpp,hpp,java setlocal tabstop=4 shiftwidth=4 expandtab
  au Filetype yaml setlocal tabstop=2 shiftwidth=2 expandtab
  au Filetype xml setlocal autoindent tabstop=4 shiftwidth=4 noexpandtab
  au Filetype sql setlocal tabstop=4 shiftwidth=4 expandtab
  au Filetype markdown,md,txt,text,asciidoc setlocal textwidth=79 foldenable autoindent
  au Filetype haskell setlocal tabstop=2 shiftwidth=2 expandtab
  au Filetype markdown setlocal conceallevel=2
  au Filetype markdown setlocal spell
  au Filetype gitcommit setlocal spell

  " Ensure tabs don't get converted to spaces in Makefiles.
  au FileType make setlocal noexpandtab

  " Make sure all types of requirements.txt files get syntax highlighting.
  au BufNewFile,BufRead requirements*.txt set syntax=python

  " Set common autoformatters.
  augroup autoformat_settings
    autocmd FileType bzl AutoFormatBuffer buildifier
    autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
    autocmd FileType go AutoFormatBuffer gofmt
    autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
    autocmd FileType java AutoFormatBuffer google-java-format
    autocmd FileType python AutoFormatBuffer black
    autocmd FileType nix AutoFormatBuffer nixpkgs-fmt
    autocmd FileType haskell AutoFormatBuffer ormolu
    autocmd FileType ocaml AutoFormatBuffer ocamlformat
  augroup END

  """
  """ Vim keybindings config starts here
  """

  " More convenient exit from normal mode
  inoremap jk <ESC>

  " Unmap space from default <right>, map it to leader instead (ignore select
  " mode)
  nnoremap <SPACE> <Nop>
  map <SPACE> <Leader>
  sunmap <Space>

  " Sane movement through wrapping lines
  noremap j gj
  noremap k gk
  " Prevent x from overriding what's in the default register.
  " (_ is the black-hole register, vim's equivalent of /dev/null)
  noremap x "_x
  noremap X "_x

  " Cycle splits
  nnoremap <S-Tab> <C-w>w

  " Consistent behaviour for uppercase mappings
  nnoremap Y y$
  noremap H ^
  noremap L $

  " Don't go to Ex mode, or edit command-line history, or use backspace
  map q: <Nop>
  map Q <Nop>
  noremap <BS> <Nop>

  " Copy to system clibpoard.
  nnoremap <Space>c "+yy
  vnoremap <Space>c "+y
  nnoremap <Space>v "+p
  vnoremap <Space>v "+p

  " Skip quickfix buffer when moving through buffers.
  function! BSkipQuickFix(command)
    let start_buffer = bufnr('%')
    execute a:command
    while &buftype ==# 'quickfix' && bufnr('%') != start_buffer
      execute a:command
    endwhile
  endfunction

  " Close the current buffer and move to the previous one
  " This replicates the idea of closing a tab
  nmap <Leader>q :call BSkipQuickFix("bp") <BAR> bd #<CR>

  " Move to the next buffer
  nmap <Leader>] :call BSkipQuickFix("bn")<CR>

  " Move to the previous buffer
  nmap <Leader>[ :call BSkipQuickFix("bp")<CR>

  " Use arrows for resizing
  nnoremap <Up>    :resize -2<CR>
  nnoremap <Down>  :resize +2<CR>
  nnoremap <Left>  :vertical resize +2<CR>
  nnoremap <Right> :vertical resize -2<CR>

  " Use . for each line of visual block
  vnoremap . :normal .<CR>

  " Shortcuts for 3-way merge
  map <Leader>1 :diffget LOCAL<CR>
  map <Leader>2 :diffget BASE<CR>
  map <Leader>3 :diffget REMOTE<CR>

  """
  """ Lua config starts here
  """

  lua <<EOF
  -- nvim-tree requires netrw to be disabled as early as possible, before the
  -- netrw plugin has a chance to load.
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- Disable mouse
  vim.o.mouse = ""

  -- Don't highlight long lines
  vim.o.synmaxcol = 256

  -- Proper tabs (common languages/format)
  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
  vim.o.expandtab = true
  -- Visually indent wrapped lines, thus preserving horizontal blocks of text
  vim.o.breakindent = true

  -- Show the matching part of the pair for [] {} and ()
  vim.o.showmatch = true

  -- Set default split behaviour
  vim.o.splitbelow = true
  vim.o.splitright = true

  -- Show line numbers
  vim.o.number = true

  -- Enable relative line numbers
  vim.o.rnu = true

  -- Keep some lines within window when moving
  vim.o.scrolloff =  5

  -- Smarter case-sensitive search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Assume s/../../g
  vim.o.gdefault = true

  -- Visible 80-character mark
  vim.o.colorcolumn = '80'

  -- Show a visual line under the cursor's current line (slows down a LOT)
  vim.o.cursorline = false

  -- Blink cursor on error instead of beeping
  vim.o.visualbell = true

  -- Enable folding based on same indendation level
  vim.o.foldmethod = 'indent'
  -- Do not fold regions automatically
  vim.o.foldlevel = 99

  -- Highlight bad whitespace, folded regions and conceal
  vim.cmd [[highlight BadWhitespace ctermbg=red guibg=red]]
  vim.cmd [[highlight Folded ctermfg=darkgrey ctermbg=NONE]]
  vim.cmd [[highlight Conceal ctermfg=58 ctermbg=NONE]]

  -- Sign icons.
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = '',
        [vim.diagnostic.severity.INFO] = '',
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      },
    },
  })

  -- Persist the undo tree for each file
  vim.o.undofile = true

  -- Better diff algorithm
  vim.o.diffopt = vim.o.diffopt .. ',algorithm:patience'

  -- Use 24-bit colors.
  vim.o.termguicolors = true

  ---
  --- Vim plugins config starts here
  ---

  -- Rainbow Parentheses Improved
  vim.g.rainbow_active = 1

  -- Neomake
  vim.fn['neomake#configure#automake']('w')
  vim.g.neomake_open_list = 2

  require('telescope').setup()
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('ui-select')

  require('trouble').setup()
  require('gitsigns').setup()

  require('nvim-treesitter-textobjects').setup {
    select = {
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      lookbehind = false,
    },
    move = {
      set_jumps = true, -- whether to set jumps in the jumplist
    },
  }

  -- Highlighting and indentation are opt-in per buffer.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
      if not lang then
        return
      end
      -- Only enable where parser from Nix is present.
      if not pcall(vim.treesitter.start, args.buf, lang) then
        return
      end
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  vim.g.no_python_maps = true
  vim.g.no_go_maps = true
  vim.g.no_vim_maps = true
  vim.g.no_ocaml_maps = true

  local ts_select = require('nvim-treesitter-textobjects.select')
  local ts_move = require('nvim-treesitter-textobjects.move')
  local function map(modes, lhs, fn, query)
    vim.keymap.set(modes, lhs, function() fn(query, 'textobjects') end,
      { noremap = true, silent = true })
  end

  -- You can use the capture groups defined in textobjects.scm
  local sel = { 'x', 'o' }
  map(sel, 'af', ts_select.select_textobject, '@function.outer')
  map(sel, 'if', ts_select.select_textobject, '@function.inner')
  map(sel, 'ac', ts_select.select_textobject, '@class.outer')
  map(sel, 'ic', ts_select.select_textobject, '@class.inner')

  local mv = { 'n', 'x', 'o' }
  map(mv, ']m', ts_move.goto_next_start, '@function.outer')
  map(mv, ']]', ts_move.goto_next_start, '@class.outer')
  map(mv, ']M', ts_move.goto_next_end, '@function.outer')
  map(mv, '][', ts_move.goto_next_end, '@class.outer')
  map(mv, '[m', ts_move.goto_previous_start, '@function.outer')
  map(mv, '[[', ts_move.goto_previous_start, '@class.outer')
  map(mv, '[M', ts_move.goto_previous_end, '@function.outer')
  map(mv, '[]', ts_move.goto_previous_end, '@class.outer')

  require('nvim-tree').setup()

  require('symbols-outline').setup()
 
  require('lualine').setup {
    options = {
      icons_enabled = true,
      -- component_separators = '|',
      -- section_separators = "" -- cannot use double single-quotes here
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'lsp_progress', 'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    tabline = {
        lualine_a = {'buffers'},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
  }

  mapping_opts = { noremap = true, silent = true } 

  -- Telescope global mappings
  vim.api.nvim_set_keymap('n', 'go', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], mapping_opts)
  vim.api.nvim_set_keymap('n', 'gp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], mapping_opts)
  vim.api.nvim_set_keymap('n', 'gb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], mapping_opts)
  vim.api.nvim_set_keymap('n', 'gh', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], mapping_opts)

  -- NvimTree mappings
  vim.api.nvim_set_keymap('n', '<C-k>', ':NvimTreeToggle<CR>', mapping_opts)
  vim.api.nvim_set_keymap('n', '<C-a>', ':NvimTreeFindFile<CR>', mapping_opts)

  -- Disable inline diagnostics.
  vim.diagnostic.config({virtual_text = true, update_on_insert = false})
  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
      vim.diagnostic.enable(false)
    end
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      vim.diagnostic.enable(true)
    end
  })

  local on_attach = function(client, bufnr)
     -- Omnifunc mapping is <C-x><C-o>.
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings.
    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', '[]', [[<cmd>lua vim.lsp.buf.hover()<CR>]], opts)
    buf_set_keymap('n', 'gd', [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
    buf_set_keymap('n', 'gD', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
    buf_set_keymap('n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts)
    buf_set_keymap('n', 'gi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]], opts)
    buf_set_keymap('n', 'gt', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], opts)
    buf_set_keymap('n', '<leader>D', [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
    buf_set_keymap('n', '<leader>rn', [[<cmd>lua vim.lsp.buf.rename()<CR>]], opts)
    buf_set_keymap('n', '<leader>ac', [[<cmd>lua vim.lsp.buf.code_action()<CR>]], opts)
    buf_set_keymap('n', '<leader>e', [[<cmd>lua vim.diagnostic.open_float()<CR>]], opts)
    buf_set_keymap('n', '[d', [[<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>]], opts)
    buf_set_keymap('n', ']d', [[<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>]], opts)
    -- buf_set_keymap('n', '<leader>q', [[<cmd>lua vim.diagnostic.setloclist()<CR>]], opts)
    buf_set_keymap('n', '<leader>Q', [[<cmd>lua vim.diagnostic.setqflist()<CR>]], opts)
    -- buf_set_keymap('n', '<C-s>', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], opts)

    if client.server_capabilities.documentFormattingProvider then
      buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
    end
    if client.server_capabilities.documentRangeFormattingProvider then
      buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
      vim.cmd [[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      ]]
      local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
      vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
      vim.api.nvim_create_autocmd('CursorHold', {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    --require "lsp_signature".on_attach({
    --   bind = true, -- This is mandatory, otherwise border config won't get registered.
    --   zindex = 50, -- Send to bottom of z-stack of floating windows.
    --   handler_opts = {
    --     border = "rounded"
    --   }
    --}, bufnr)
  end

  -- Setup nvim-cmp for autocompletion.
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  local function t(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
      local col = vim.fn.col "." - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
  end

  local function tab(fallback)
      if cmp.visible() then
          cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
          vim.fn.feedkeys(t "<Plug>luasnip-expand-or-jump", "")
      elseif check_back_space() then
          vim.fn.feedkeys(t "<tab>", "n")
      else
          fallback()
      end
  end

  local function shift_tab(fallback)
      if cmp.visible() then
          cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
          vim.fn.feedkeys(t "<Plug>luasnip-jump-prev", "")
      else
          fallback()
      end
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "s" }),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
      { name = 'path' },
    })
  })

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  luasnip.config.set_config {
      history = true,
  }
  require("luasnip.loaders.from_vscode").lazy_load()

  -- Default LSP capabilities (extended by nvim-cmp).
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  vim.lsp.config('*', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.api.nvim_set_keymap('n', '<leader><CR>', [[<cmd>lua require('trouble').next({ mode = 'diagnostics', jump = true })<CR>]], mapping_opts)
  vim.api.nvim_set_keymap('n', '<leader>xx', [[<cmd>Trouble diagnostics toggle<CR>]], mapping_opts)

  vim.cmd('colorscheme material')
''
+ (if withHaskell then ''
  vim.lsp.enable('hls')
'' else "")
+ (if withWriting then ''
  -- Markdown
  vim.g.vim_markdown_new_list_item_indent = 2
  vim.g.vim_markdown_frontmatter = 1

  -- Setup zen-mode.
  require("zen-mode").setup(
  {
    window = {
      backdrop = 0.95,
      width = 110,
      height = 0.7,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        scrolloff = 999,
        list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      twilight = { enabled = true },
      gitsigns = { enabled = false },
      tmux = { enabled = true },
      alacritty = {
        enabled = true,
        font = "11",
      },
    },
    on_open = function(win)
    end,
    on_close = function()
    end,
  })
'' else "")
+ (if withOCaml then ''
  vim.lsp.enable('ocamllsp')
'' else "")
  + ''
  EOF
''

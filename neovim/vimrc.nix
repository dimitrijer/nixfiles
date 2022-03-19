{ withWriting ? false }:

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

" Unset paste on InsertLeave.
au InsertLeave * silent! set nopaste

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
" Prevent x from overriding what's in the clipboard.
" (_ is the black-hole register, vim's equivalent of /dev/null)
noremap x "_x
noremap X "_x

" Cycle splits
nnoremap <S-Tab> <C-w>w

" Toggle paste mode
set pastetoggle=<F9>

" Don't go to Ex mode, or edit command-line history
map q: <Nop>
map Q <Nop>

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
""" Vim plugins config starts here
"""

" Treesitter
lua <<EOF
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

-- Use OS X clipboard
vim.o.clipboard = 'unnamed'

-- Highlight bad whitespace, folded regions and conceal
vim.cmd [[highlight BadWhitespace ctermbg=red guibg=red]]
vim.cmd [[highlight Folded ctermfg=darkgrey ctermbg=NONE]]
vim.cmd [[highlight Conceal ctermfg=58 ctermbg=NONE]]

-- Needed for vim-markdown.
-- highlight htmlItalic cterm=italic
-- highlight htmlBold cterm=bold

-- Persist the undo tree for each file
vim.o.undofile = true

-- Better diff algorithm
vim.o.diffopt = vim.o.diffopt .. ',algorithm:patience'

require('telescope').setup()
require('telescope').load_extension('fzf')

require('gitsigns').setup()

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

require('nvim-tree').setup()

local kanagawa = require('lualine.themes.kanagawa')
for _, mode in pairs(kanagawa) do 
  mode.a.gui = nil
end
vim.cmd('colorscheme kanagawa')

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = kanagawa
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
vim.api.nvim_set_keymap('n', '<C-p>', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], mapping_opts)
vim.api.nvim_set_keymap('n', '<C-s>g', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], mapping_opts)
vim.api.nvim_set_keymap('n', '<Leader>p', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], mapping_opts)

-- NvimTree mappings
vim.api.nvim_set_keymap('n', '<C-k>', ':NvimTreeToggle<CR>', mapping_opts)
vim.api.nvim_set_keymap('n', '<C-a>', ':NvimTreeFindFile<CR>', mapping_opts)

local nvim_lsp = require 'lspconfig'

local on_attach = function(client, bufnr)
   -- Omnifunc mapping is <C-x><C-o>.
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'gD', [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
  buf_set_keymap('n', 'gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
  buf_set_keymap('n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts)
  buf_set_keymap('n', 'K', [[<cmd>lua vim.lsp.buf.hover()<CR>]], opts)
  buf_set_keymap('n', 'gi', [[<cmd>lua vim.lsp.buf.implementation()<CR>]], opts)
  buf_set_keymap('n', '<leader>D', [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
  buf_set_keymap('n', '<leader>rn', [[<cmd>lua vim.lsp.buf.rename()<CR>]], opts)
  buf_set_keymap('n', '<leader>ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]], opts)
  buf_set_keymap('n', '<leader>e', [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]], opts)
  buf_set_keymap('n', '<leader>t', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], opts)
  buf_set_keymap('n', '[d', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], opts)
  buf_set_keymap('n', ']d', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], opts)
  -- buf_set_keymap('n', '<leader>q', [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]], opts)
  buf_set_keymap('n', '<leader>Q', [[<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>]], opts)
  -- buf_set_keymap('n', '<C-s>', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  require "lsp_signature".on_attach({
     bind = true, -- This is mandatory, otherwise border config won't get registered.
     handler_opts = {
       border = "rounded"
     }
   }, bufnr)
end

local configs = require('lspconfig/configs')
configs.hls = {
 default_config = {
   cmd = {'haskell-language-server-wrapper', '--lsp'};
   filetypes = {'haskell', 'lhaskell'};
   root_dir = nvim_lsp.util.root_pattern("stack.yaml", ".hie-bios", "WORKSPACE", "cabal.config", "package.yaml", "hie.yaml", "hie.yml");
   settings = {};
 };
}

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
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Load friendly snippets.
luasnip.config.set_config {
    history = true,
}
require("luasnip.loaders.from_vscode").load()

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
nvim_lsp.hls.setup{
    on_attach = on_attach;
    capabilities = capabilities;
}

EOF

" Neomake
call neomake#configure#automake('w')
let g:neomake_open_list = 2
let g:rainbow_active = 1

''
+ (if withWriting then ''
" Goyo
let g:goyo_width = 100

" Auto-enable Limelight in Goyo
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  set scl=no
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  set scl=yes
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Markdown
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_frontmatter = 1

'' else "")

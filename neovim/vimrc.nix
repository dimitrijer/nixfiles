{ withWriting ? false }:

''
" Running in nix, so ignore ~/.vim
set runtimepath-=~/.vim

"""
""" General Vim config
"""

" Disable mouse
set mouse=""

" Don't highlight long lines
set synmaxcol=256

" Italics start/end
set t_ZH=[3m
set t_ZR=[23m

" Proper tabs (common languages/format)
set tabstop=4
set shiftwidth=4
set expandtab
" Visually indent wrapped lines, thus preserving horizontal blocks of text
set breakindent

" Show the matching part of the pair for [] {} and ()
set showmatch

" Set default split behaviour
set splitbelow
set splitright

" Show line numbers
set number

" Enable relative line numbers
set rnu

" Keep some lines within window when moving
set scrolloff=5

" Smarter case-sensitive search
set ignorecase
set smartcase

" Assume s/../../g
set gdefault

" 80-line column
if exists('+colorcolumn')
    set colorcolumn=80
    highlight ColorColumn ctermbg=red
endif

" Show a visual line under the cursor's current line (slows down a LOT)
" set cursorline

" Blink cursor on error instead of beeping
set visualbell

" Enable folding
set foldmethod=indent
" Do not fold regions automatically
set foldlevel=99

" Use OS X clipboard
set clipboard=unnamed

" Dark mode
set background=dark
colorscheme base16-tomorrow-night

" Highlight bad whitespace, folded regions and conceal
highlight BadWhitespace ctermbg=red guibg=red
highlight Folded ctermfg=darkgrey ctermbg=NONE
highlight Conceal ctermfg=58 ctermbg=NONE
" Needed for vim-markdown.
highlight htmlItalic cterm=italic
highlight htmlBold cterm=bold

" Protect against crash-during-write...
set writebackup
" ... but do not persist backup after successful write
set nobackup

" Use rename-and-write-new method whenever safe
set backupcopy=auto

" Protect changes between writes. Default values of updatecount (200
" keystrokes) and updatetime (4 seconds) are fine
set swapfile

" Persist the undo tree for each file
set undofile

" Better diff algorithm
set diffopt+=internal,algorithm:patience

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
" Ensure tabs don't get converted to spaces in Makefiles.
au FileType make setlocal noexpandtab
" Make sure all types of requirements.txt files get syntax highlighting.
au BufNewFile,BufRead requirements*.txt set syntax=python

" Unset paste on InsertLeave.
au InsertLeave * silent! set nopaste

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

" To open a new empty buffer
nmap <Leader>t :enew<cr>

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

" NERDTree shortcut
map <C-k> :NERDTreeToggle<CR>
map <C-a> :NERDTreeFind<CR>

" Shortcuts for 3-way merge
map <Leader>1 :diffget LOCAL<CR>
map <Leader>2 :diffget BASE<CR>
map <Leader>3 :diffget REMOTE<CR>

"""
""" Vim plugins config starts here
"""

" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}
EOF

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16_tomorrow'
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" RainbowParen
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['white',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

" NERDTree
let NERDTreeMapActivateNode='<space>'
let g:NERDTreeNodeDelimiter = "\u00a0"
" Open NERDTree automatically if no files were specified, and change focus to
" new buffer.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd w | endif

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" fzf
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
" Make open with fzf work while in NERD tree.
function! FZFOpen(command_str)
  if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction
" Map a few common things to do with FZF.
nnoremap <silent> <C-p> :call FZFOpen(':FZF -m')<CR>
nnoremap <silent> <Leader>p :call FZFOpen(':Buffers')<CR>
nnoremap <silent> <C-s>b :call FZFOpen(':BLines')<CR>
nnoremap <silent> <C-s>l :call FZFOpen(':Lines')<CR>

" CoC
" set completeopt=menuone,noinsert,preview
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
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
  SignifyEnable
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Markdown
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_frontmatter = 1

'' else "")
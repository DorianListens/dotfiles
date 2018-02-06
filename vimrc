set nocompatible
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kchmck/vim-coffee-script'
Plug 'airblade/vim-gitgutter'
Plug 'adrianolaru/vim-adio'
Plug 'tpope/vim-commentary'
Plug 'mustache/vim-mustache-handlebars'
Plug 'tpope/vim-surround'
Plug 'cakebaker/scss-syntax.vim'
Plug 'jgdavey/tslime.vim'
Plug 'tpope/vim-fugitive'
Plug 'Valloric/YouCompleteMe'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'keith/tmux.vim'
Plug 'mileszs/ack.vim'
Plug 'wavded/vim-stylus'

" This call automatically re-enables filetype and enables syntax highlighting
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spacing and Indentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=2
set expandtab 
set softtabstop=2
set shiftwidth=2
set autoindent

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Keymappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
let mapleader = " "
imap <c-c> <esc>
" Get current file path upto directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" Switch between last two files
nnoremap <leader><leader> <c-^> 

" You Will Learn...
nnoremap <Left> :echoe "NO! Use h"<CR>
nnoremap <Right> :echoe "NO! Use l"<CR>
nnoremap <Up> :echoe "NO! Use k"<CR>
nnoremap <Down> :echoe "NO! Use j"<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase smartcase
set hlsearch
set incsearch
set t_ti= t_te=
" Clear syntax highlighting with enter
nnoremap <CR> :nohlsearch<CR><CR>

nnoremap <leader>f :CtrlP<CR>

if executable('rg')
  " Use rg over Grep
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
  let g:ctrlp_user_command = 'rg %s -l -g "" --files'
  " rg is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
  let g:ackprg ='rg --vimgrep --no-heading'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YCMD Config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap gd :YcmCompleter GoToDefinition<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Display Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable	" Use syntax highlighting
set ruler
set number	" Show line numbers
set relativenumber
set showcmd
set showmatch
set wildmenu
set enc=utf-8
set splitbelow
set splitright
set signcolumn=yes
"if a file is changed outside of vim, automatically reload it without asking
set autoread
let g:gitgutter_realtime = 1

" Automatic Window Size
:silent! set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
:silent! set winheight=5
:silent! set winminheight=5
:silent! set winheight=999


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Scheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme adio

" highlight the cursorline, which adio doesn't do.
hi CursorLine       ctermfg=none ctermbg=234 cterm=none
hi LineNr           ctermfg=243  ctermbg=233  cterm=none
hi Visual           ctermfg=none ctermbg=236  cterm=none
set cursorline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sessions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:let dir=fnamemodify(getcwd(), ':t')
:let sessiondir=$HOME.'/.vim/sessions/'.dir.'/'
:let sessionpath=sessiondir.'session.vim'
:let restorestring=':mksession! '. sessionpath 

" execute "nmap SQ" . restorestring
nmap SQ :call MakeSession(sessiondir, restorestring)<cr>

function! MakeSession(sessiondir, restorestring)
  if !isdirectory(a:sessiondir)
    silent call mkdir (a:sessiondir, 'p')
  endif
  execute a:restorestring
  exec 'wqa'
endfunction

function! RestoreSession(sessionpath)
  if argc() == 0 "vim called without arguments
    if filereadable(a:sessionpath)
      execute 'source '. a:sessionpath
    endif
  end
endfunction
autocmd VimEnter * call RestoreSession(sessionpath)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Window Swapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction

nnoremap <silent> <leader>mw :call MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call DoWindowSwap()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clear all buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Wipeout()
  " list of *all* buffer numbers
  let l:buffers = range(1, bufnr('$'))

  " what tab page are we in?
  let l:currentTab = tabpagenr()
  try
    " go through all tab pages
    let l:tab = 0
    while l:tab < tabpagenr('$')
      let l:tab += 1

      " go through all windows
      let l:win = 0
      while l:win < winnr('$')
        let l:win += 1
        " whatever buffer is in this window in this tab, remove it from
        " l:buffers list
        let l:thisbuf = winbufnr(l:win)
        call remove(l:buffers, index(l:buffers, l:thisbuf))
      endwhile
    endwhile

    " if there are any buffers left, delete them
    if len(l:buffers)
      execute 'bwipeout' join(l:buffers)
    endif
  finally
    " go back to our original tab page
    execute 'tabnext' l:currentTab
  endtry
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Junk Drawer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This makes RVM work inside Vim. I have no idea why.
set shell=bash

" Sometimes when searching for things, the display encoding gets messed up
" if that happens, type :fix
cnoremap fix :!echo -e '\ec\e(K\e[J'


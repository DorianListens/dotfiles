set nocompatible
filetype off    " Required
" Spacing and Indentation
set tabstop=2
set expandtab 
set softtabstop=2
set shiftwidth=2
" Basic Keymappings
let mapleader = " "
imap <c-c> <esc>
" Get current file path upto directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" Switch between last two files
nnoremap <leader><leader> <c-^> 
set showcmd
set showmatch

" This makes RVM work inside Vim. I have no idea why.
set shell=bash

" Searching
set ignorecase smartcase
set hlsearch
set incsearch
set t_ti= t_te=
" Clear syntax highlighting with enter
nnoremap <CR> :nohlsearch<CR><CR>
let g:ackprg = 'ag --nogroup --nocolor --column'
nnoremap <leader>f :CtrlP<CR>
nnoremap <leader>sc :Ag --coffee 
nnoremap <leader>sr :Ag --ruby 
nnoremap <leader>sa :Ag --sass 

cnoremap fix :!echo -e '\ec\e(K\e[J'
if executable('ag')
  " Use Ag over Grep
   set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
   let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
   let g:ctrlp_use_caching = 0
endif


" Vundle Plugins
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'kchmck/vim-coffee-script'
Plugin 'airblade/vim-gitgutter'
Plugin 'adrianolaru/vim-adio'
Plugin 'git://github.com/tpope/vim-commentary'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-surround'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'thoughtbot/vim-rspec'
Plugin 'jgdavey/tslime.vim'


" Basic Display Settings
set ruler
set number	" Show line numbers
set relativenumber
syntax enable	" Use syntax highlighting
set background=dark
colorscheme adio
" highlight the cursorline, which adio doesn't do.
hi CursorLine       ctermfg=none ctermbg=234 cterm=none
hi LineNr           ctermfg=243  ctermbg=233  cterm=none
hi Visual           ctermfg=none ctermbg=236  cterm=none
set cursorline
set wildmenu
set enc=utf-8
set splitbelow
set splitright
" Window Size
:silent! set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
:silent! set winheight=5
:silent! set winminheight=5
:silent! set winheight=999
"if a file is changed outside of vim, automatically reload it without asking
set autoread
let g:gitgutter_realtime = 1
let g:gitgutter_sign_column_always = 1
filetype plugin indent on " Required

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

" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

let g:rspec_command = 'call Send_to_Tmux("spring rspec {spec}\n")'


" You Will Learn...
nnoremap <Left> :echoe "NO! Use h"<CR>
nnoremap <Right> :echoe "NO! Use l"<CR>
nnoremap <Up> :echoe "NO! Use k"<CR>
nnoremap <Down> :echoe "NO! Use j"<CR>

" Sessions
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
" Window Swapping
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

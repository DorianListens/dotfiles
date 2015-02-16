set nocompatible
filetype off    " Required
" Spacing and Indentation
set tabstop=2
set expandtab 
set shiftwidth=2
" Basic Keymappings
let mapleader = " "
imap <c-c> <esc>
set clipboard=unnamed
" Get current file path upto directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" Switch between last two files
nnoremap <leader><leader> <c-^> 
set showcmd
" Searching
set ignorecase smartcase
set hlsearch
set incsearch
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
Plugin 'kien/ctrlp.vim'
Plugin 'rking/ag.vim'

" Basic Display Settings
set ruler
set number	" Show line numbers
syntax enable	" Use syntax highlighting
set background=dark
colorscheme adio
set cursorline
set enc=utf-8
set splitbelow
set splitright
" Window Size
set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=5
set winminheight=5
set winheight=999
"if a file is changed outside of vim, automatically reload it without asking
set autoread
let g:gitgutter_realtime = 1
let g:gitgutter_sign_column_always = 1
filetype plugin indent on " Required


" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
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
" Selecta Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a given vim command on the results of fuzzy selecting from a given
" shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
   try
     let selection = system(a:choice_command . " | selecta " .  a:selecta_args)
   catch /Vim:Interrupt/
" Swallow the ^C so that the redraw below happens; otherwise
"there will be
" leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

function! SelectaFile(path)
  call SelectaCommand("find " . a:path . "/* -type f", "", ":e")
endfunction

" nnoremap <leader>f :call SelectaFile(".")<cr>
nnoremap <leader>gv :call SelectaFile("app/views")<cr>
nnoremap <leader>gc :call SelectaFile("app/controllers")<cr>
nnoremap <leader>gm :call SelectaFile("app/models")<cr>
nnoremap <leader>gh :call SelectaFile("app/helpers")<cr>
nnoremap <leader>gl :call SelectaFile("lib")<cr>
nnoremap <leader>gp :call SelectaFile("public")<cr>
nnoremap <leader>gs :call SelectaFile("public/stylesheets")<cr>
nnoremap <leader>gf :call SelectaFile("features")<cr>

function! SelectaIdentifier()
" Yank the word under the cursor into the z register
  normal "zyiw
" Fuzzy match files in the current directory, starting with the word  under
" the cursor
  call SelectaCommand("find * -type f", "-s " . @z, ":e")
endfunction
nnoremap <c-g> :call SelectaIdentifier()<cr>


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

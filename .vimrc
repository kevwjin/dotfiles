
" -- vim-plug ------------------------------------------------------------------

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'NLKNguyen/papercolor-theme'
Plug 'vimwiki/vimwiki'
Plug 'cormacrelf/vim-colors-github'
Plug 'chriskempson/base16-vim'
Plug 'wellle/context.vim'
" Plug 'vim-airline/vim-airline'
call plug#end()

" -- status line ---------------------------------------------------------------

set statusline+=%F " show full path of current file

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      " left/right separator
set statusline+=%c,     " cursor column
set statusline+=%l/%L   " cursor line/total lines
set statusline+=\ %P    " percent through file
set laststatus=2        " always show status line

" -- general -------------------------------------------------------------------
" colorscheme
set t_Co=256   " This is may or may not needed.
set background=light
colorscheme PaperColor
" let g:airline_theme='papercolor'

" vimwiki required settings
set nocompatible
:filetype plugin on
syntax on
let g:vimwiki_list = [{'path': '~/vimwiki/',
      \ 'syntax': 'markdown', 'ext': '.md'}]
" incomplete tasks
function! VimwikiFindIncompleteTasks()
  lvimgrep /- \[ \]/ %:p
  lopen
endfunction

function! VimwikiFindAllIncompleteTasks()
  VimwikiSearch /- \[ \]/
  lopen
endfunction
" line numbers
set number
set relativenumber
" indenting 
set tabstop=2
set shiftwidth=3
set softtabstop=3
set expandtab
set autoindent
autocmd FileType python setlocal tabstop=3 shiftwidth=3 softtabstop=3
" copy and paste to and from Vim
set clipboard=unnamed
" remove error bells
set noerrorbells
set vb t_vb = 
set belloff=all
" removes backup
set nobackup
set undodir=~/.vim/undodir
set undofile
" search as you type
set incsearch
" remove highlight search
set nohlsearch
" search case sensitive when there are uppercase letters
" set smartcase
set ignorecase
" disables auto comments after newline of original comment
autocmd FileType c,java inoreabbrev <buffer> /** /**<CR>/<Up>
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" natural splits
set splitbelow
set splitright
" resize split when resize terminal 
autocmd VimResized * wincmd = 
" escape to normal mode from terminal mode for nvim
if has('nvim')
  tnoremap <C-[> <C-\><C-n>
endif
" indented text wrapping when whitespace
set breakindent
set breakindentopt=shift:2
set linebreak
" set leader key
let mapleader = " "
" auto close {
function! s:CloseBracket()
  let line = getline('.')
  if line =~# '^\s*\(struct\|class\|enum\) '
    return "{\<Enter>};\<Esc>O"
  elseif searchpair('(', '', ')', 'bmn', '', line('.'))
    " Probably inside a function call. Close it off.
    return "{\<Enter>});\<Esc>O"
  else
    return "{\<Enter>}\<Esc>O"
  endif
endfunction
inoremap <expr> {<Enter> <SID>CloseBracket()
" reformat file and retain current position
nnoremap g= mmgg=G`m
set backspace=indent,eol,start
" shows the file name in the title bar
set title
" remove swp files
set noswapfile
" always show sign column
" set signcolumn=yes
" Allow j and k commands to navigate soft-wrapped lines without 'g'
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" python mode
let g:pymode_python = 'python3'
let g:pymode_trim_whitespaces = 0
" paste mode toggle
set pastetoggle=<F10>

" --- fzf ----------------------------------------------------------------------

" default fzf layout
" - Popup window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'PreProc'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

" --- template -----------------------------------------------------------------

autocmd BufNewFile *.cpp 0r ~/.vim/templates/skeleton.cpp

" --- compile run settings -----------------------------------------------------

" <leader>m to test for errors
" <leader>n to show output
" Java
autocmd FileType java nnoremap <leader>m :w <bar> :set makeprg=javac\ %<CR>:Make<CR>
autocmd FileType java nnoremap <leader>n :w <bar> :ter java -cp %:p:h %:t:r <CR>
" C++
autocmd FileType cpp nnoremap <leader>m :w <bar> :set makeprg=g++\ --std=c++17\ %\ -o\ %<<CR>:Make<CR>
autocmd FileType cpp nnoremap <leader>n :w <bar> :ter ./%< <CR>

" the following code only works with nvim
set hidden

function! TermWrapper(command) abort
  if !exists('g:split_term_style') | let g:split_term_style = 'vertical' | endif
  if g:split_term_style ==# 'vertical'
    let buffercmd = 'vnew'
  elseif g:split_term_style ==# 'horizontal'
    let buffercmd = 'new'
  else
    echoerr 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'' but is currently set to ''' . g:split_term_style . ''')'
    throw 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'')'
  endif
  if exists('g:split_term_resize_cmd')
    exec g:split_term_resize_cmd
  endif
  exec buffercmd
  exec 'term ' . a:command
  exec 'setlocal nornu nonu'
  exec 'startinsert'
endfunction

command! -nargs=0 CompileAndRun call TermWrapper(printf('g++ -std=c++11 %s && ./a.out', expand('%')))
command! -nargs=1 CompileAndRunWithFile call TermWrapper(printf('g++ -std=c++11 %s && ./a.out < %s', expand('%'), <args>))
autocmd FileType cpp nnoremap <leader>r :w<bar>:CompileAndRun<CR>

let g:split_term_style = 'vertical'

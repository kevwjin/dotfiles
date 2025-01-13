-- install plug.vim
vim.cmd [[
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
]]
-- install color scheme
vim.cmd [[
  call plug#begin('~/.vim/plugged')
  Plug 'NLKNguyen/papercolor-theme'
  call plug#end()
]]
-- set colorscheme
vim.cmd('colorscheme PaperColor')
vim.opt.termguicolors = true
vim.opt.background = 'light'

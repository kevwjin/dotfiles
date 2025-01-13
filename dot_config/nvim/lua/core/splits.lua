-- vertical split resize increments
vim.keymap.set('n', '<C-w>>', ':vertical resize -10<CR>')
vim.keymap.set('n', '<C-w><', ':vertical resize +10<CR>')
-- horizontal split resize increments
vim.keymap.set('n', '<C-w>+', ':resize +5<CR>')
vim.keymap.set('n', '<C-w>-', ':resize -5<CR>')
-- set split divider character
vim.opt.fillchars = "vert:|"
-- set foreground and background color for split divider element
vim.cmd('highlight VertSplit guifg=#005f87 ctermfg=4')
vim.cmd('highlight VertSplit guibg=NONE ctermbg=NONE')
-- resize splits when resizing window
vim.api.nvim_exec([[
  autocmd VimResized * wincmd =
]], false)
-- remove vertical split divider background
vim.opt.splitright = true
vim.opt.splitbelow = true

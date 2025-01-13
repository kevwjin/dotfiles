-- disable mouse
  -- (cannot highlight path on status bar when mouse enabled)
vim.opt.mouse = ''
-- show full path of the current file
vim.opt.statusline:append('%F ')
-- display a warning if 'paste' is set
vim.opt.statusline:append('%#error#%{&paste?"[paste]":""}%*')
-- left/right separator
vim.opt.statusline:append('%=')

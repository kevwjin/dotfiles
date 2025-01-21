-- map leader key for telescope key mappings
-- * leader mapping must be before require statement
vim.g.mapleader = ','
-- remove netrw banner
vim.g.netrw_banner = 0

-- set floating window background color
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })

-- enable gutter
vim.opt.signcolumn = 'yes'
-- draw vertical line at 80th column
vim.opt.colorcolumn = '80'
-- set block cursor in all modes
vim.cmd([[set guicursor=a:block"]])

-- set line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- disable search highlighting
vim.opt.hlsearch = false
-- ignore case when lower-cased search
vim.opt.ignorecase = true
-- case-sensitive when mix-cased search
vim.opt.smartcase = true

-- set line wrapping
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.breakindentopt = 'shift:2'
-- remap j and k to move through wrapped lines
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true })

-- set tab options
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
-- set JSON indentation to 4 spaces
vim.cmd([[
  autocmd FileType json setlocal shiftwidth=4 tabstop=4
]])

-- disable automatic comments on newline
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- allow copy and paste to and from nvim
vim.opt.clipboard:append("unnamedplus")

-- disable swap files
vim.opt.swapfile = false
-- safe undo history
vim.opt.undofile = true

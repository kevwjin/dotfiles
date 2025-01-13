return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPre', 'BufNewFile' },
  build = ':TSUpdate',
  dependencies = {
    'windwp/nvim-ts-autotag',
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require('nvim-treesitter.configs')
    -- configure treesitter
    treesitter.setup({
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure language parser installation
      ensure_installed = {
        'json',
        'javascript',
        'typescript',
        'tsx',
        'yaml',
        'html',
        'css',
        'markdown',
        'markdown_inline',
        'bash',
        'lua',
        'vim',
        'dockerfile',
        'gitignore',
        'python',
        'java',
      },
      incremental_selection = {
        enable = true,
				keymaps = {
    		  init_selection = "<CR>",     -- start selection
    		  node_incremental = "<CR>",   -- increment selection
    		  node_decremental = "<BS>",   -- decrement selection
    		  scope_incremental = "<TAB>", -- increment to scope
    		},
      },
    })
  end,
}

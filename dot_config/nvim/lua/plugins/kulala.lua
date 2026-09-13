return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  opts = {},
  config = function()
    local kulala = require('kulala')
    kulala.setup()

    vim.keymap.set('n', '<leader>rr', kulala.run, { desc = 'Run HTTP request' })
    vim.keymap.set('n', '<leader>rn', kulala.jump_next, { desc = 'Jump to next HTTP request' })
    vim.keymap.set('n', '<leader>rp', kulala.jump_prev, { desc = 'Jump to prev HTTP request' })
  end,
}

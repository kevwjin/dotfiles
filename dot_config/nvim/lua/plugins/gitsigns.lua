return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gitsigns = require('gitsigns')
    gitsigns.setup({
      signcolumn = true,
      signs_staged_enable = true,
    })

    vim.keymap.set('n', ']h', gitsigns.next_hunk, { desc = 'Next hunk' })
    vim.keymap.set('n', '[h', gitsigns.prev_hunk, { desc = 'Prev hunk' })
    vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
    vim.keymap.set({ 'n', 'v' }, '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
    vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
  end,
}

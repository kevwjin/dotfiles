return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      defaults = {
        path_display = { 'smart' },
        borderchars = {
          prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└"},
          results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
      }
    })
    telescope.load_extension('fzf')

    local keymap = vim.keymap
    local builtin = require('telescope.builtin')
    keymap.set('n', '<leader>fd', function()
        builtin.find_files({
            prompt_title = "< Directory Search >",
            find_command = { "find", ".", "-type", "d" }
        })
    end, { desc = 'Search for file dirs under project dir' })
    keymap.set('n', '<leader>ff', builtin.find_files,
      { desc = 'Search for file names under project dir' })
    keymap.set('n', '<leader>fp', builtin.live_grep,
      { desc = 'Search for string in file contents under project dir' })
    keymap.set('n', '<leader>fs', builtin.buffers,
      { desc = 'Search for file names in open buffers' })
    keymap.set('n', '<leader>fw', builtin.grep_string,
      { desc = 'Search for current word in file contents under project dir' })
    keymap.set('n', '<leader>fo', builtin.oldfiles,
      { desc = 'Search for file names in file history' })
    keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find,
      { desc = 'Search for string in current buffer contents' })
  end,
}

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
        preview = {
          treesitter = false,
        },
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

    local function git_root_dir()
      local git_root = vim.fs.dirname(vim.fs.find('.git', { upward = true })[1] or '')
      if git_root == '' then
        return nil
      end

      return git_root
    end

    local function git_root_search_dirs()
      local git_root = git_root_dir()
      if git_root == nil then
        return nil
      end

      return { git_root }
    end

    local function exclude_gitignore()
      return { '--no-ignore', '--hidden', '--glob', '!.gitignore' }
    end

    local function exclude_docs_dirs()
      return { '!docs/**', '!**/docs/**' }
    end

    local function live_grep_git_tracked_files()
      builtin.live_grep({
        additional_args = exclude_gitignore,
        search_dirs = git_root_search_dirs(),
        glob_pattern = exclude_docs_dirs(),
      })
    end

    local function current_token()
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2] + 1
      local token_pattern = '[%a_][%w_]*'
      local start_col, end_col = nil, nil

      for s, e in line:gmatch('()' .. token_pattern .. '()') do
        if s <= col and col < e then
          start_col = s
          end_col = e
          break
        end
      end

      if start_col == nil then
        return vim.fn.expand('<cword>')
      end

      return line:sub(start_col, end_col - 1)
    end

    local function grep_git_tracked_word()
      local search = current_token()

      builtin.grep_string({
        search = search,
        use_regex = false,
        additional_args = exclude_gitignore,
        search_dirs = git_root_search_dirs(),
        glob_pattern = exclude_docs_dirs(),
      })
    end

    keymap.set('n', '<leader>fd', function()
        builtin.find_files({
            prompt_title = "< Directory Search >",
            cwd = git_root_dir(),
            find_command = { "find", ".", "-type", "d" }
        })
    end, { desc = 'Search for file dirs under project dir' })
    keymap.set('n', '<leader>ff', function()
      builtin.find_files({ cwd = git_root_dir() })
    end, { desc = 'Search for file names under project dir' })
    keymap.set('n', '<leader>fp', live_grep_git_tracked_files,
      { desc = 'Search for string in repo files' })
    keymap.set('n', '<leader>fs', builtin.buffers,
      { desc = 'Search for file names in open buffers' })
    keymap.set('n', '<leader>fw', grep_git_tracked_word,
      { desc = 'Search for current token in repo files' })
    keymap.set('n', '<leader>fo', builtin.oldfiles,
      { desc = 'Search for file names in file history' })
    keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find,
      { desc = 'Search for string in current buffer contents' })
  end,
}

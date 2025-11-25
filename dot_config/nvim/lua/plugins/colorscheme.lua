return {
  "NLKNguyen/papercolor-theme",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.cmd([[
      set background=light
      colorscheme PaperColor
    ]])
  end,
}

-- return {
--   {
--     name = "academic",
--     dir = vim.fn.stdpath("config") .. "/academic",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       vim.opt.runtimepath:prepend(vim.fn.stdpath("config") .. "/academic")
--       vim.opt.termguicolors = true
--       vim.cmd([[colorscheme academic]])
--     end,
--   },
-- }

return {
  {
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
}

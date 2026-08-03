return {
  "NLKNguyen/papercolor-theme",
  lazy = false,
  priority = 1000,
  config = function()
    local function get_hl(name)
      return vim.api.nvim_get_hl(0, { name = name, link = false })
    end

    local function first_defined(...)
      for i = 1, select("#", ...) do
        local value = select(i, ...)
        if value ~= nil then
          return value
        end
      end
    end

    local function first_contrasting(bg, ...)
      for i = 1, select("#", ...) do
        local value = select(i, ...)
        if value ~= nil and value ~= bg then
          return value
        end
      end
    end

    local function apply_float_highlights()
      local normal = get_hl("Normal")
      local line_nr = get_hl("LineNr")
      local comment = get_hl("Comment")
      local border = get_hl("VertSplit")
      local normal_bg = first_defined(normal.bg, 0xeeeeee)
      local border_fg = first_contrasting(normal_bg, border.fg, line_nr.fg, comment.fg, normal.fg, 0x444444)

      vim.api.nvim_set_hl(0, "NormalFloat", {
        fg = normal.fg,
        bg = normal_bg,
      })
      vim.api.nvim_set_hl(0, "FloatBorder", {
        fg = border_fg,
        bg = normal_bg,
      })
    end

    vim.opt.termguicolors = true
    vim.opt.winblend = 0
    vim.cmd([[
      set background=light
      colorscheme PaperColor
    ]])

    apply_float_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = apply_float_highlights,
    })
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

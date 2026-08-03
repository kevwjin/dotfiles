return {
  "otavioschwanck/arrow.nvim",
  dependencies = {},
  opts = {
    leader_key = '!',
    buffer_leader_key = 'm',  -- per buffer mark
    show_icons = false,
    hide_handbook = true,     -- hide keybind handbook
  },
  config = function(_, opts)
    local save_keys = require("arrow.save_keys")
    local default_cwd = save_keys.cwd

    save_keys.cwd = function()
      local cwd = default_cwd()
      if cwd and cwd ~= "" then
        return cwd
      end

      cwd = vim.fn.getcwd()
      if cwd and cwd ~= "" then
        return cwd
      end

      return vim.env.PWD or vim.env.HOME or "."
    end

    require("arrow").setup(opts)
  end,
}

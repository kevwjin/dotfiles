return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  keys = {
    { "<leader>cd", "<cmd>CodeDiff<cr>", desc = "CodeDiff: repo status" },
    { "<leader>cp", "<cmd>CodeDiff pr<cr>", desc = "CodeDiff: pull request" },
    { "<leader>ch", "<cmd>CodeDiff history<cr>", desc = "CodeDiff: history" },
  },
  config = function()
    local showtabline = vim.o.showtabline
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeDiffOpen",
      callback = function()
        showtabline = vim.o.showtabline
        vim.o.showtabline = 0
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeDiffClose",
      callback = function()
        vim.o.showtabline = showtabline
      end,
    })

    require("codediff").setup({
      keymaps = {
        view = {
          toggle_explorer = "<leader>b",
          focus_explorer = "<leader>e",
        },
      },
    })
  end,
}

return {
  'neovim/nvim-lspconfig',
  -- tag = 'v0.1.7',  -- Use a version compatible with the older Mason versions
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    -- 'williamboman/mason.nvim',
    -- 'williamboman/mason-lspconfig.nvim',
    -- sync update of imports
    { 'antosha417/nvim-lsp-file-operations', config = true },
  },
  config = function()
    local lspconfig = require('lspconfig')
    local mason_lspconfig = require('mason-lspconfig')
    local keymap = vim.keymap

    -- LSP keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
        opts.desc = "Show diagnostics under cursor"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
      end,
    })

    -- disable inline messages (virtual text)
    vim.diagnostic.config({
      virtual_text = false,
      -- keep gutter signs
      signs = true,
      -- keep underlines
      underline = true,
    })

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({})
      end,
      -- lua handler
      ["lua_ls"] = function()
        lspconfig["lua_ls"].setup({
          settings = {
            Lua = {
              -- make the 
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })
      end,
    })
  end,
}

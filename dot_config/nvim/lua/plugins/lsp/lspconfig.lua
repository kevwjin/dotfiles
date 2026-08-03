return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lsp_windows = require("lspconfig.ui.windows")
    local keymap = vim.keymap

    local bordered_float = { border = "single" }

    lsp_windows.default_options.border = bordered_float.border

    vim.lsp.handlers["textDocument/hover"] =
      vim.lsp.with(vim.lsp.handlers.hover, bordered_float)

    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, bordered_float)

    -- rust-analyzer is provided by your Nix devshell, not Mason.
    vim.lsp.enable("rust_analyzer")

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client then
          client.server_capabilities.semanticTokensProvider = nil
        end

        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", function()
          vim.lsp.buf.definition({ reuse_win = true })
        end, opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", function()
          vim.lsp.buf.implementation({ reuse_win = true })
        end, opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", function()
          vim.lsp.buf.type_definition({ reuse_win = true })
        end, opts)

        opts.desc = "Show hover documentation"
        keymap.set("n", "K", function()
          vim.lsp.buf.hover(bordered_float)
        end, opts)

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

    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      float = {
        border = bordered_float.border,
      },
    })
  end,
}

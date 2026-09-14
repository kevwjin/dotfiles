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

    local function css_import_under_cursor()
      local line = vim.api.nvim_get_current_line()
      if not line:match("^%s*import") then
        return nil
      end

      local _, _, specifier = line:find("['\"]([^'\"]+%.css)['\"]")
      if not specifier then
        return nil
      end

      local start_col = assert(line:find(specifier, 1, true))
      local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1
      if cursor_col < start_col or cursor_col >= start_col + #specifier then
        return nil
      end

      return specifier
    end

    local function go_to_css_import()
      local specifier = css_import_under_cursor()
      if not specifier then
        return false
      end

      local current_file = vim.api.nvim_buf_get_name(0)
      local from_dir = vim.fs.dirname(current_file)
      local resolver = table.concat({
        "const path = require('node:path')",
        "const { createRequire } = require('node:module')",
        "const from = path.join(process.argv[1], '__nvim_resolve__.js')",
        "console.log(createRequire(from).resolve(process.argv[2]))",
      }, ";")
      local result = vim.system(
        { "node", "-e", resolver, from_dir, specifier },
        { text = true }
      ):wait()

      if result.code ~= 0 then
        return false
      end

      local resolved = vim.trim(result.stdout or "")
      if resolved == "" then
        return false
      end

      -- Workspace packages commonly publish copied assets from dist/.
      -- Prefer the authored src/ asset when the corresponding file exists.
      local source = resolved:gsub("/dist/", "/src/", 1)
      if vim.uv.fs_stat(source) then
        resolved = source
      end

      vim.cmd.edit(vim.fn.fnameescape(resolved))
      return true
    end

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
          if go_to_css_import() then
            return
          end

          vim.lsp.buf.definition({ reuse_win = true })
        end, opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", function()
          vim.lsp.buf.implementation({ reuse_win = true })
        end, opts)

        if client and client.name == "ts_ls" then
          opts.desc = "Go to TypeScript source definition"
          keymap.set("n", "gS", function()
            local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

            client:request("workspace/executeCommand", {
              command = "_typescript.goToSourceDefinition",
              arguments = { params.textDocument.uri, params.position },
            }, function(err, result)
              if err then
                vim.notify(err.message, vim.log.levels.ERROR)
                return
              end

              if not result or vim.tbl_isempty(result) then
                vim.notify("No source definition found", vim.log.levels.INFO)
                return
              end

              vim.lsp.util.show_document(result[1], client.offset_encoding, {
                focus = true,
                reuse_win = true,
              })
            end, ev.buf)
          end, opts)
        end

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

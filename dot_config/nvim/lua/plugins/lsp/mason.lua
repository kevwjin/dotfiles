return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
  },
  config = function()
    -- import mason
    local mason = require('mason')
    -- import mason-lspconfig
    local mason_lspconfig = require('mason-lspconfig')
    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = '+',
          package_pending = '~',
          package_uninstalled = '-'
        }
      }
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "astro",                             -- astro framework
        "cssls",                             -- css
        "html",                              -- html
        "bashls",                            -- bash
        "clangd",                            -- c/c++
        "pyright",                           -- python
        "lua_ls",                            -- lua
        "jdtls",                             -- java
        "dockerls",                          -- dockerfile
        "docker_compose_language_service",   -- docker compose
        "nil_ls",                            -- nix
      },
    })

    require('lspconfig').zls.setup{}
  end,
}

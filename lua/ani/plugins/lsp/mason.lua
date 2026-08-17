return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- Check if mason-lspconfig is available and setup accordingly
    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if mason_lspconfig_ok then
      mason_lspconfig.setup({
        -- list of servers for mason to install
        ensure_installed = {
          "lua_ls",
          "svelte",
          "pyright", -- python
          "graphql",
          "emmet_ls",
          "html",
          "cssls",
          "tailwindcss",
          "eslint",
          "ts_ls", -- typescript
          "jsonls",
        },
        -- Try both field names for compatibility
        automatic_installation = true,
      })
    end

    -- Optional: mason-tool-installer for formatters and linters
    local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
    if mason_tool_installer_ok then
      mason_tool_installer.setup({
        ensure_installed = {
          "prettier", -- prettier formatter
          "stylua", -- lua formatter
          "isort", -- python formatter
          "black", -- python formatter
          "pylint", -- python linter
          "eslint_d", -- js linter
        },
      })
    end
  end,
}

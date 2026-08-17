return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },

  config = function()
    --------------------------------------------------
    -- Capabilities
    --------------------------------------------------
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    --------------------------------------------------
    -- LSP Keymaps
    --------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local keymap = vim.keymap

        keymap.set(
          "n",
          "gR",
          "<cmd>Telescope lsp_references<CR>",
          vim.tbl_extend("force", opts, { desc = "References" })
        )
        keymap.set(
          "n",
          "gD",
          vim.lsp.buf.declaration,
          vim.tbl_extend("force", opts, { desc = "Declaration" })
        )
        keymap.set(
          "n",
          "gd",
          "<cmd>Telescope lsp_definitions<CR>",
          vim.tbl_extend("force", opts, { desc = "Definitions" })
        )
        keymap.set(
          "n",
          "gi",
          "<cmd>Telescope lsp_implementations<CR>",
          vim.tbl_extend("force", opts, { desc = "Implementations" })
        )
        keymap.set(
          "n",
          "gt",
          "<cmd>Telescope lsp_type_definitions<CR>",
          vim.tbl_extend("force", opts, { desc = "Type definitions" })
        )

        keymap.set(
          { "n", "v" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code actions" })
        )
        keymap.set(
          "n",
          "<leader>rn",
          vim.lsp.buf.rename,
          vim.tbl_extend("force", opts, { desc = "Rename" })
        )

        keymap.set(
          "n",
          "<leader>D",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" })
        )
        keymap.set(
          "n",
          "<leader>d",
          vim.diagnostic.open_float,
          vim.tbl_extend("force", opts, { desc = "Line diagnostics" })
        )
        keymap.set(
          "n",
          "[d",
          vim.diagnostic.goto_prev,
          vim.tbl_extend("force", opts, { desc = "Prev diagnostic" })
        )
        keymap.set(
          "n",
          "]d",
          vim.diagnostic.goto_next,
          vim.tbl_extend("force", opts, { desc = "Next diagnostic" })
        )

        keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
        keymap.set(
          "n",
          "<leader>rs",
          "<cmd>LspRestart<CR>",
          vim.tbl_extend("force", opts, { desc = "Restart LSP" })
        )
      end,
    })

    --------------------------------------------------
    -- Diagnostics UI
    --------------------------------------------------
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "󰠠",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
    })

    --------------------------------------------------
    -- LSP Server Configs (NEW API)
    --------------------------------------------------
    vim.lsp.config.lua_ls = {
      capabilities = capabilities,
      settings = {
        Lua = {
          format = { enable = false },
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
          workspace = { checkThirdParty = false },
        },
      },
    }

    vim.lsp.config.pyright = {
      cmd = { "pyright-langserver", "--stdio" },
      root_markers = { ".git", "pyproject.toml", "pyrightconfig.json" },
      settings = {
        python = {
          -- Keep your specific path
          pythonPath = "/opt/homebrew/bin/python3.11",
          analysis = {
            -- FALSE = Fast. Relies on stubs (which modern Numpy has).
            useLibraryCodeForTypes = false,
            -- ONLY current file = Fast.
            diagnosticMode = "openFilesOnly",
            autoSearchPaths = true,
            typeCheckingMode = "basic",
          },
        },
      },
    }
    vim.lsp.enable("pyright")

    vim.lsp.config.svelte = {
      capabilities = capabilities,
      on_attach = function(client)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    }

    vim.lsp.config.graphql = { capabilities = capabilities }
    vim.lsp.config.emmet_ls = { capabilities = capabilities }

    --------------------------------------------------
    -- Mason
    --------------------------------------------------
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "pyright",
        "svelte",
        "graphql",
        "emmet_ls",
      },
    })

    --------------------------------------------------
    -- Enable servers (Neovim 0.11+)
    --------------------------------------------------
    vim.lsp.enable({
      "lua_ls",
      "pyright",
      "svelte",
      "graphql",
      "emmet_ls",
    })
  end,
}

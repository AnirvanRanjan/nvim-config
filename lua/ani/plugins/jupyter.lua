-- ════════════════════════════════════════════════════════════════════════
-- Jupyter notebooks in Neovim (no-compromise stack)
--   jupytext.nvim  -> open/save .ipynb as editable markdown (outputs preserved)
--   molten-nvim    -> run cells on a real Jupyter kernel, inline output
--   image.nvim     -> render plots/images inline (kitty protocol; iTerm2 3.5+)
--   quarto + otter -> full LSP (pyright) inside code cells
--
-- Notebook-specific keymaps + quarto activation live in ftplugin/markdown.lua
-- and are scoped to .ipynb buffers only, so your Obsidian .md notes are
-- completely untouched.
--
-- External deps (install once, see the chat notes):
--   brew install imagemagick
--   /opt/homebrew/bin/python3.11 -m pip install pynvim jupyter_client \
--       nbformat cairosvg pillow ipykernel jupytext
--   then in nvim:  :UpdateRemotePlugins   (and restart)
-- ════════════════════════════════════════════════════════════════════════
return {
  -- 1. Convert .ipynb <-> markdown transparently on open/save.
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false, -- must be loaded to intercept opening a .ipynb
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },

  -- 2. Inline images. iTerm2 (>= 3.5.6) speaks the kitty graphics protocol.
  --    processor = "magick_cli" avoids the finicky Lua-rock; just needs the
  --    ImageMagick CLI (brew install imagemagick).
  {
    "3rd/image.nvim",
    ft = { "markdown", "python" },
    -- Don't let lazy build image.nvim's `magick` luarock (hererocks isn't set
    -- up, and we don't need it): the magick_cli processor below shells out to
    -- the ImageMagick CLI from `brew install imagemagick` instead.
    build = false,
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      -- No auto-integrations: molten drives image.nvim directly, and this
      -- keeps images from rendering in your regular markdown / Obsidian notes.
      integrations = {},
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- 3. The code runner. Loads when you first run a Molten command.
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
    cmd = {
      "MoltenInit",
      "MoltenEvaluateOperator",
      "MoltenEvaluateLine",
      "MoltenEvaluateVisual",
      "MoltenReevaluateCell",
      "MoltenImportOutput",
      "MoltenExportOutput",
      "MoltenEnterOutput",
      "MoltenHideOutput",
      "MoltenDelete",
    },
    init = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true

      -- Load a notebook's saved outputs when opened, and write outputs back
      -- into the .ipynb on save. Guarded so nothing errors before a kernel
      -- is running.
      local aug = vim.api.nvim_create_augroup("ani_molten_ipynb", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = aug,
        pattern = "*.ipynb",
        callback = function()
          local ok, status = pcall(require, "molten.status")
          if ok and status.initialized() == "Molten" then
            pcall(vim.cmd, "MoltenExportOutput!")
          end
        end,
      })
    end,
  },

  -- 4. LSP (pyright) inside code cells, plus a convenient cell runner that
  --    delegates to molten. Activated only for .ipynb (see ftplugin).
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown" },
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lspFeatures = {
        languages = { "python" },
        chunks = "all",
        diagnostics = { enabled = true, triggers = { "BufWritePost" } },
        completion = { enabled = true },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
  },
}

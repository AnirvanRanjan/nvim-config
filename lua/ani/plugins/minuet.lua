-- Minuet: Copilot-style inline (ghost-text) completion powered by
-- Ollama + qwen2.5-coder:3b, a fill-in-the-middle (FIM) code model.
-- This complements codecompanion.lua, which also uses qwen2.5-coder:3b:
--   * minuet (this file) = as-you-type autocomplete
--   * codecompanion      = on-demand chat / inline edits / refactor / explain
return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- Load when a code file opens (so we can warm the model early) or on first
  -- insert — whichever happens first.
  event = "InsertEnter",
  ft = { "python", "lua", "java", "javascript", "typescript", "sh", "html", "css", "markdown" },
  config = function()
    require("minuet").setup({
      provider = "openai_fim_compatible",
      -- One completion at a time keeps a local model light on resources.
      n_completions = 1,
      -- Start small; bump this up later if your machine keeps up comfortably.
      context_window = 512,
      -- The 3b model on an 8GB machine often takes >3s (the default), and a
      -- FIM timeout returns NO completion silently. Give it room. (The warm-up
      -- below keeps the model loaded so requests stay fast.)
      request_timeout = 5,
      notify = "warn",
      -- Strip completion text that duplicates what's already after the cursor —
      -- e.g. the closing bracket nvim-autopairs auto-inserts for you. FIM models
      -- disable this by default (0); a positive value re-enables the dedup so you
      -- don't get doubled `)`, `]`, `}` or quotes.
      after_cursor_filter_length = 15,
      provider_options = {
        openai_fim_compatible = {
          -- Ollama ignores the key, but the field must be a valid env var name.
          api_key = "TERM",
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          -- 3b (~1.9GB) is noticeably smarter than 1.5b and still tiny.
          model = "qwen2.5-coder:3b",
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
      },
      virtualtext = {
        -- Auto-suggest as you type in these filetypes. Empty the list to make
        -- completion manual-only (invoke with <A-]> / <A-[>).
        auto_trigger_ft = {
          "python",
          "lua",
          "java",
          "javascript",
          "typescript",
          "sh",
          "html",
          "css",
          "markdown",
        },
        -- NOTE: macOS terminals often send accented characters for Option/Alt
        -- (e.g. Option+A -> "Å"), which breaks <A-...> maps. So the everyday
        -- actions below use Ctrl keys that work in any terminal. All of these
        -- fire in INSERT mode (that's where ghost text lives).
        keymap = {
          accept = "<C-g>", -- accept the whole suggestion
          accept_line = "<C-l>", -- accept one line
          accept_n_lines = "<A-z>", -- accept N lines (needs Option-as-Meta)
          prev = "<A-[>", -- cycle to previous (needs Option-as-Meta)
          next = "<A-]>", -- cycle to next (needs Option-as-Meta)
          dismiss = "<C-]>", -- dismiss the suggestion
        },
      },
    })

    -- ── Keep the model warm ──────────────────────────────────────────────
    -- The first completion of a session is slow because Ollama has to load
    -- the model into memory. We fire an async, no-output request that just
    -- loads it (empty prompt) and sets a 1h keep-alive, so it's ready before
    -- you finish reading the file. Because this plugin loads on opening a code
    -- file (see `ft` above), the warm-up starts the moment you enter one.
    local last_warm = 0
    local function warm_model()
      local now = os.time()
      if now - last_warm < 60 then
        return -- throttle: don't spam Ollama when switching files quickly
      end
      last_warm = now
      vim.fn.jobstart({
        "curl",
        "-s",
        "-m",
        "120",
        "http://localhost:11434/api/generate",
        "-d",
        '{"model":"qwen2.5-coder:3b","keep_alive":"1h","prompt":""}',
      })
    end

    -- Warm now (the file that just loaded this plugin), and again whenever a
    -- code file is opened — so a model unloaded after a long idle gets
    -- reloaded proactively rather than on your next keystroke.
    warm_model()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "python", "lua", "java", "javascript", "typescript", "sh", "html", "css", "markdown" },
      callback = warm_model,
      desc = "Warm up the Ollama completion model",
    })
  end,
}

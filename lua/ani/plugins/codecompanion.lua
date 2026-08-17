-- CodeCompanion: local AI coding assistant powered by Ollama + qwen2.5-coder:3b
-- Chat, inline edits, refactors, tests, explanations — all running locally.
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  -- Lazy-load on first command or keypress
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCmd",
  },
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI: Action palette" },
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI: Toggle chat" },
    -- These call our custom prompts below (placement forced to "add"/"replace")
    -- instead of the generic `:CodeCompanion <prompt>` command. The generic
    -- command asks the LLM to *classify* where output should go (buffer vs.
    -- new buffer vs. chat), and small local models often get that
    -- classification wrong, which is why edits kept landing in a new
    -- buffer/chat instead of your current file.
    { "<leader>ai", "<cmd>CodeCompanion /gen<cr>", mode = "n", desc = "AI: Generate code here" },
    { "<leader>ai", ":'<,'>CodeCompanion /replace<cr>", mode = "v", desc = "AI: Replace selection" },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "AI: Add selection to chat" },
  },
  opts = {
    adapters = {
      http = {
        -- Point the built-in Ollama adapter at qwen2.5-coder:3b running locally.
        -- Ollama's default URL (http://localhost:11434) is used automatically.
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "qwen2.5-coder:3b",
              },
            },
          })
        end,
      },
    },
    interactions = {
      -- Chat + inline now use Google Gemini (free tier: Gemini 3 Flash).
      -- The built-in "gemini" adapter reads the API key from the GEMINI_API_KEY
      -- environment variable — the key is NEVER stored in this file (this repo is
      -- public on GitHub). Set it in your shell instead:  export GEMINI_API_KEY=...
      chat = {
        adapter = { name = "gemini", model = "gemini-3.6-flash" },
        opts = {
          system_prompt = [[You are a coding assistant inside Neovim. Be direct and skip filler — no restating the question, no "Certainly!", no summaries of what you just did.

If the user asks for code or a code change: reply with the code and at most one short sentence of context. Do not write step-by-step plans or pseudocode unless asked.

If the user asks a conceptual, general, or "why/how" question: give a complete, thorough explanation.

Format code in Markdown code blocks with the correct language id. Do not use H1 or H2 headers.]],
        },
      },
      inline = { adapter = { name = "gemini", model = "gemini-3.6-flash" } },
      -- Command generation stays local (offline fallback, no quota use).
      cmd = { adapter = "ollama" },
    },
    opts = {
      log_level = "ERROR",
    },
    prompt_library = {
      -- Inline prompts with a forced `placement`, so CodeCompanion doesn't ask
      -- the (small, local) model to classify where output should go — that
      -- classification is what made edits land in a new buffer.
      --
      -- IMPORTANT: we deliberately do NOT set our own output-format system
      -- prompt here. The inline interaction injects a hidden system prompt that
      -- makes the model return JSON, which the plugin then parses. Overriding it
      -- (e.g. "reply with only the code, no code fences") makes the model return
      -- raw code and breaks the parser -> "[Inline] Failed to parse the response".
      -- The single user note below only reinforces CodeCompanion's own rules.
      ["Generate Code"] = {
        interaction = "inline",
        description = "Write code at the cursor, in this file",
        opts = {
          alias = "gen",
          placement = "add", -- insert at cursor in the CURRENT buffer
          user_prompt = true, -- ask what to generate when invoked
          modes = { "n" },
        },
        prompts = {
          {
            role = "user",
            content = "Match the surrounding code's style and indentation.",
            opts = { visible = false },
          },
        },
      },
      ["Replace Selection"] = {
        interaction = "inline",
        description = "Rewrite the selected code, in place",
        opts = {
          alias = "replace",
          placement = "replace", -- replace the visual selection
          user_prompt = true, -- ask what change to make when invoked
          modes = { "v" },
        },
        prompts = {
          {
            role = "user",
            content = "Rewrite only the selected code. Keep its indentation and style.",
            opts = { visible = false },
          },
        },
      },
    },
  },
}

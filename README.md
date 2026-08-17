# Neovim Configuration

My personal Neovim setup, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Structure

- `init.lua` — entry point
- `lua/ani/core/` — options and keymaps
- `lua/ani/plugins/` — one file per plugin
- `lua/ani/lazy.lua` — plugin manager bootstrap

## Highlights

- LSP via mason + nvim-lspconfig, completion via nvim-cmp
- Local AI, fully offline via [Ollama](https://ollama.com):
  - **CodeCompanion** — chat and inline edits
  - **minuet** — Copilot-style as-you-type completion
  - both run on `qwen2.5-coder:3b`
- Telescope, nvim-tree, treesitter, gitsigns, trouble, which-key, and more

## Requirements

- Neovim ≥ 0.9
- [Ollama](https://ollama.com) with the `qwen2.5-coder:3b` model for the AI features:
  ```
  ollama pull qwen2.5-coder:3b
  ```

## Install

```
git clone <repo-url> ~/.config/nvim
nvim
```

lazy.nvim bootstraps and installs all plugins on first launch.

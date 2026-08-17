<div align="center">

# ⚡ Neovim

### A fast, modern, IDE-grade Neovim configuration — with a fully local AI copilot.

<p>
  <img src="https://img.shields.io/badge/Neovim-0.9+-57A143?style=for-the-badge&logo=neovim&logoColor=white" alt="Neovim" />
  <img src="https://img.shields.io/badge/Made%20with-Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" alt="Lua" />
  <img src="https://img.shields.io/badge/Manager-lazy.nvim-8B5CF6?style=for-the-badge" alt="lazy.nvim" />
  <img src="https://img.shields.io/badge/AI-Local%20(Ollama)-000000?style=for-the-badge&logo=ollama&logoColor=white" alt="Local AI" />
</p>

<p>
  <img src="https://img.shields.io/github/last-commit/AnirvanRanjan/nvim-config?style=flat-square&color=57A143" alt="Last commit" />
  <img src="https://img.shields.io/github/repo-size/AnirvanRanjan/nvim-config?style=flat-square&color=8B5CF6" alt="Repo size" />
  <img src="https://img.shields.io/github/languages/top/AnirvanRanjan/nvim-config?style=flat-square" alt="Top language" />
  <img src="https://img.shields.io/github/stars/AnirvanRanjan/nvim-config?style=flat-square&color=FDB813" alt="Stars" />
</p>

</div>

---

A personal, modular Neovim setup built on [`lazy.nvim`](https://github.com/folke/lazy.nvim) — full LSP, Treesitter, fuzzy finding, formatting, linting, git integration, and a **completely offline AI assistant** powered by [Ollama](https://ollama.com). No API keys, no cloud, no subscriptions — the AI runs on your own machine.

<div align="center">

**[Features](#-features) · [Requirements](#%EF%B8%8F-requirements) · [Install](#-installation) · [AI Setup](#-local-ai) · [Keymaps](#%EF%B8%8F-keybindings) · [Plugins](#-plugins) · [Structure](#%EF%B8%8F-structure)**

</div>

---

## ✨ Features

- 🧠 **Local AI copilot** — chat, inline edits, and Copilot-style ghost-text completion, all running offline via Ollama + `qwen2.5-coder:3b`
- 🔌 **Full LSP** — auto-installed language servers via [mason](https://github.com/williamboman/mason.nvim), rich diagnostics, code actions, rename, hover
- 🌳 **Treesitter** — accurate syntax highlighting, auto-tag closing, and context-aware commenting
- 🔭 **Fuzzy everything** — [Telescope](https://github.com/nvim-telescope/telescope.nvim) with native FZF sorting for files, live grep, and symbols
- 🎨 **Polished UI** — [Tokyo Night](https://github.com/folke/tokyonight.nvim) theme, `lualine`, animated cursor, `noice` command UI, and a dashboard on startup
- 🧹 **Format & lint on save** — `conform.nvim` (Prettier, Stylua, Black, isort) and `nvim-lint` (ESLint, Pylint)
- 🌿 **Git in your gutter** — stage, reset, preview, and blame hunks without leaving the buffer
- 📝 **Markdown & notes** — Obsidian integration, live preview, auto-capitalization, and spell-check
- ⚡ **Quality-of-life** — autosave, session restore, code runner, CSV viewer, and code screenshots

---

## 🖼️ Requirements

| Requirement | Why |
| :--- | :--- |
| **Neovim** ≥ 0.9 | Core editor |
| A **[Nerd Font](https://www.nerdfonts.com/)** | Icons in the UI, file tree, and statusline |
| **[ripgrep](https://github.com/BurntSushi/ripgrep)** | Telescope live-grep |
| **[Ollama](https://ollama.com)** + `qwen2.5-coder:3b` | Local AI (chat, inline, autocomplete) |
| **Node.js** | Prettier, ESLint, and several language servers |
| **Python 3.11** (`/opt/homebrew/bin/python3.11`) | Python host + code runner |
| **make** | Builds `telescope-fzf-native` & LuaSnip regex |
| **[Deno](https://deno.com/)** *(optional)* | `peek.nvim` markdown preview |
| **[silicon](https://github.com/Aloxaf/silicon)** *(optional)* | Code screenshots |

---

## 🚀 Installation

> [!WARNING]
> Back up any existing config first — `mv ~/.config/nvim ~/.config/nvim.bak`

```bash
# 1. Clone into your Neovim config directory
git clone https://github.com/AnirvanRanjan/nvim-config.git ~/.config/nvim

# 2. Pull the local AI model (for chat, inline edits & autocomplete)
ollama pull qwen2.5-coder:3b

# 3. Launch — lazy.nvim bootstraps and installs everything on first start
nvim
```

On first launch, `lazy.nvim` installs all plugins and `mason` fetches the language servers, formatters, and linters automatically. Restart once it finishes.

---

## 🤖 Local AI

This config ships with a two-part, **100% offline** AI workflow — no data ever leaves your machine.

| Tool | Role | Model |
| :--- | :--- | :--- |
| **[CodeCompanion](https://github.com/olimorris/codecompanion.nvim)** | Chat, inline generation & refactors | `qwen2.5-coder:3b` |
| **[Minuet](https://github.com/milanglacier/minuet-ai.nvim)** | Copilot-style as-you-type completion | `qwen2.5-coder:3b` |

The model is **warmed up automatically** when you open a code file, so completions are ready by the time you type. All requests go to a local Ollama server at `http://localhost:11434`.

```
<leader>ac   → toggle AI chat          <C-g>  → accept ghost-text suggestion
<leader>ai   → inline generate/replace  <C-l>  → accept one line
<leader>aa   → AI action palette         ga     → add selection to chat (visual)
```

---

## ⌨️ Keybindings

> Leader key is <kbd>Space</kbd>. Exit insert mode with `jk`.

<details open>
<summary><b>🔭 Find & Navigate</b></summary>

| Key | Action |
| :--- | :--- |
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fs` | Live grep |
| `<leader>fc` | Grep word under cursor |
| `<leader>ft` | Find TODOs |
| `<leader>ee` | Toggle file explorer |
| `<leader>ef` | Explorer on current file |
| `[b` / `]b` | Previous / next buffer |
| `tx` | Pick a buffer to close |

</details>

<details>
<summary><b>🧠 LSP</b></summary>

| Key | Action |
| :--- | :--- |
| `gd` / `gD` | Definition / declaration |
| `gR` | References |
| `gi` / `gt` | Implementations / type defs |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>d` / `<leader>D` | Line / buffer diagnostics |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>td` | Toggle diagnostics |
| `<leader>rs` | Restart LSP |

</details>

<details>
<summary><b>🌿 Git (Gitsigns)</b></summary>

| Key | Action |
| :--- | :--- |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk |
| `<leader>hS` / `<leader>hR` | Stage / reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` / `<leader>hB` | Blame line / toggle blame |
| `<leader>hd` | Diff this |

</details>

<details>
<summary><b>🤖 AI · 🧹 Format · 🩺 Diagnostics</b></summary>

| Key | Action |
| :--- | :--- |
| `<leader>ac` / `<leader>ai` / `<leader>aa` | AI chat / inline / actions |
| `<C-g>` / `<C-l>` | Accept completion / one line |
| `<leader>mp` | Format file or selection |
| `<leader>l` | Lint current file |
| `<leader>xx` | Toggle Trouble list |
| `<leader>xd` / `<leader>xw` | Document / workspace diagnostics |

</details>

<details>
<summary><b>⚡ Editing & Windows</b></summary>

| Key | Action |
| :--- | :--- |
| `<A-Up>` / `<A-Down>` | Move line up / down |
| `<A-S-Down>` | Duplicate line |
| `<leader>sv` / `<leader>sh` | Split vertical / horizontal |
| `<leader>se` / `<leader>sx` | Equalize / close split |
| `<leader>sm` | Maximize split |
| `<leader>r` | Run code (floating window) |
| `<leader>nh` | Clear search highlight |
| `<leader>cf` / `<leader>cr` | Copy full / relative path |
| `<leader>oo` / `<leader>os` | New / search Obsidian note |

</details>

---

## 🧩 Plugins

<details>
<summary><b>Expand the full plugin list (40+)</b></summary>

### 🎨 UI & Appearance
| Plugin | Purpose |
| :--- | :--- |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [nvim-cokeline](https://github.com/willothy/nvim-cokeline) | Buffer tabs |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Start screen / dashboard |
| [noice.nvim](https://github.com/folke/noice.nvim) | Command-line & message UI |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | Notifications |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim) | Prettier input/select popups |
| [transparent.nvim](https://github.com/xiyaowong/transparent.nvim) | Transparent background |
| [SmoothCursor.nvim](https://github.com/gen740/SmoothCursor.nvim) | Animated cursor |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight TODO/FIX/NOTE |

### 🧠 LSP, Completion & Coding
| Plugin | Purpose |
| :--- | :--- |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configs |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Install LSPs / tools |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) + [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Snippets |
| [lspkind.nvim](https://github.com/onsails/lspkind.nvim) | Completion icons |
| [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) | Java language server |
| [neodev.nvim](https://github.com/folke/neodev.nvim) | Lua/Neovim API dev |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Linting |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics list |

### 🌳 Treesitter & Editing
| Plugin | Purpose |
| :--- | :--- |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax & parsing |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | Auto-close HTML tags |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Commenting |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround text objects |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-pair brackets |
| [substitute.nvim](https://github.com/gbprod/substitute.nvim) | Substitute operator |
| [vim-maximizer](https://github.com/szw/vim-maximizer) | Maximize splits |

### 🔭 Navigation & Git
| Plugin | Purpose |
| :--- | :--- |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs & hunks |
| [auto-session](https://github.com/rmagatti/auto-session) | Session management |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless tmux/split nav |

### 🤖 AI & Tools
| Plugin | Purpose |
| :--- | :--- |
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | AI chat & inline edits |
| [minuet-ai.nvim](https://github.com/milanglacier/minuet-ai.nvim) | AI autocomplete |
| [code_runner.nvim](https://github.com/CRAG666/code_runner.nvim) | Run code in a float |
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | Obsidian notes |
| [peek.nvim](https://github.com/toppair/peek.nvim) | Markdown live preview |
| [csvview.nvim](https://github.com/hat0uma/csvview.nvim) | CSV table viewer |
| [nvim-silicon](https://github.com/michaelrommel/nvim-silicon) | Code screenshots |
| [vim-be-good](https://github.com/ThePrimeagen/vim-be-good) | Motion practice game |

</details>

**Language servers** (auto-installed): `lua_ls` · `pyright` · `ts_ls` · `html` · `cssls` · `tailwindcss` · `emmet_ls` · `eslint` · `svelte` · `graphql` · `jsonls`

**Formatters & linters**: Prettier · Stylua · Black · isort · Pylint · eslint_d

---

## 🗂️ Structure

```
~/.config/nvim
├── init.lua                 # Entry point, host & global autocmds
├── lazy-lock.json           # Pinned plugin versions
└── lua/ani
    ├── core
    │   ├── options.lua       # Editor settings
    │   └── keymaps.lua       # General keymaps
    ├── lazy.lua              # Plugin manager bootstrap
    └── plugins
        ├── codecompanion.lua # AI chat / inline
        ├── minuet.lua        # AI autocomplete
        ├── telescope.lua     # Fuzzy finder
        ├── lsp/              # LSP, mason, jdtls
        └── ...               # One file per plugin
```

---

## 🎨 Editor Defaults

Relative + absolute line numbers · 2-space indentation · smartcase search · system clipboard · splits open right/below · no swapfile · autosave on focus loss · markdown spell-check with auto-capitalization.

---

## 📄 License

Released under the [MIT License](./LICENSE) — borrow anything you like.

<div align="center">

<sub>Built with ❤️ and far too many <code>&lt;leader&gt;</code> mappings.</sub>

</div>

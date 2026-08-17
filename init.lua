-- Core
require("ani.core")
require("ani.lazy")
-- Set the Python 3 host program explicitly
vim.g.python3_host_prog = "/opt/homebrew/bin/python3.11"
--------------------------------------------------
-- Diagnostics Toggle
--------------------------------------------------
local diagnostics_enabled = true

local function toggle_diagnostics()
  diagnostics_enabled = not diagnostics_enabled
  if diagnostics_enabled then
    vim.diagnostic.enable()
    vim.notify("Diagnostics enabled", vim.log.levels.INFO)
  else
    vim.diagnostic.disable()
    vim.notify("Diagnostics disabled", vim.log.levels.WARN)
  end
end

vim.keymap.set("n", "<leader>td", toggle_diagnostics, { desc = "Toggle diagnostics" })

--------------------------------------------------
-- Keymaps
--------------------------------------------------
local opts = { silent = true }

-- Duplicate line
vim.keymap.set("n", "<A-S-Down>", "yyp", { desc = "Duplicate line" })

-- Move lines
vim.keymap.set("n", "<A-Up>", ":m-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-Down>", ":m+<CR>==", { desc = "Move line down" })

-- Screenshot (Silicon)
vim.keymap.set("v", "<leader>sc", ":Silicon<CR>", { desc = "Snapshot code" })

-- Buffer navigation (Cokeline)
vim.keymap.set("n", "[b", "<Plug>(cokeline-focus-prev)", opts)
vim.keymap.set("n", "]b", "<Plug>(cokeline-focus-next)", opts)
vim.keymap.set("n", "tx", "<Plug>(cokeline-pick-close)", opts)

-- Obsidian
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianNew<CR>", { desc = "New Obsidian note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian notes" })

-- Select all
vim.keymap.set("n", "<leader>ya", "ggVGy", { desc = "Select all and copy" })
vim.keymap.set("n", "<leader>pa", "ggVGp", { desc = "Select all and paste" })

-- Paste over selected text without losing the current clipboard
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting register" })

-- Delete without copying to clipboard
vim.keymap.set({ "n", "v" }, "x", '"_x')
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Preview files
vim.keymap.set("n", "<leader>po", ":OmniPreview start<CR>", { silent = true })
vim.keymap.set("n", "<leader>pc", ":OmniPreview stop<CR>", { silent = true })

-- Enable CSV View with specific settings
vim.keymap.set(
  "n",
  "<leader>cv",
  "<cmd>CsvViewEnable delimiter=, display_mode=border header_lnum=1<CR>",
  { desc = "Enable CSV View" }
)
vim.keymap.set("n", "<leader>cx", "<cmd>CsvViewDisable<CR>", { desc = "Disable CSV View" })

-- Copy full path
vim.keymap.set("n", "<leader>cf", '<cmd>let @+=expand("%:p")<CR>', { desc = "Copy full path" })
-- Copy relative path
vim.keymap.set("n", "<leader>cr", '<cmd>let @+=expand("%")<CR>', { desc = "Copy relative path" })

--------------------------------------------------
-- Visual Mode Improvements
--------------------------------------------------
vim.keymap.set("v", "gg", "gg0", opts)
vim.keymap.set("v", "G", "G$", opts)

vim.keymap.set("v", 'f"', 'f"h', opts)
vim.keymap.set("v", 'F"', 'F"l', opts)
vim.keymap.set("v", "$", "$h", opts)

-- Surround helpers
vim.keymap.set("v", '"', '<esc>`>a"<esc>`<i"<esc>', { desc = "Surround with quotes" })
vim.keymap.set("v", "(", "<esc>`>a)<esc>`<i(<esc>", { desc = "Surround with ()" })
vim.keymap.set("v", "[", "<esc>`>a]<esc>`<i[<esc>", { desc = "Surround with []" })
vim.keymap.set("v", "{", "<esc>`>a}<esc>`<i{<esc>", { desc = "Surround with {}" })

--------------------------------------------------
-- Markdown Behavior
--------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.wo.conceallevel = 2
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en" }
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

-- Auto-capitalization & grammar fixes on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = function()
    vim.cmd([[silent! %s/\v([.!?]\_s*)(\l)/\1\u\2/g]])
    vim.cmd([[silent! %s/^\s*\l/\u&/g]])
    vim.cmd([[silent! %s/\<i\>/I/g]])
  end,
})

--------------------------------------------------
-- Safer Auto-Save
--------------------------------------------------
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  callback = function()
    vim.cmd("silent! update")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.lsp.enable("pyright")
  end,
})

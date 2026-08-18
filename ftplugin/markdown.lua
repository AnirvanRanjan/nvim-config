-- Notebook wiring — applies ONLY to Jupyter files (.ipynb opened as markdown by
-- jupytext). Regular markdown / Obsidian notes hit the early return below and
-- are left completely untouched.
if vim.fn.expand("%:e") ~= "ipynb" then
  return
end

local bufnr = vim.api.nvim_get_current_buf()
local function bmap(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
end

-- Molten controls (leader = space, "j" = Jupyter). These are commands, so
-- molten lazy-loads itself the first time you press one.
bmap("n", "<leader>ji", "<cmd>MoltenInit<cr>", "Jupyter: start kernel")
bmap("n", "<leader>jI", "<cmd>MoltenImportOutput<cr>", "Jupyter: import saved outputs")
bmap("n", "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<cr>", "Jupyter: open output")
bmap("n", "<leader>jh", "<cmd>MoltenHideOutput<cr>", "Jupyter: hide output")
bmap("n", "<leader>jd", "<cmd>MoltenDelete<cr>", "Jupyter: delete cell")

-- Quarto gives LSP (pyright) inside code cells + a cell runner that delegates
-- to molten. Deferred so lazy.nvim has loaded quarto before we activate it.
vim.schedule(function()
  local ok, quarto = pcall(require, "quarto")
  if not ok then
    return
  end
  quarto.activate()

  local runner = require("quarto.runner")
  bmap("n", "<leader>jr", runner.run_cell, "Jupyter: run cell")
  bmap("n", "<leader>ja", runner.run_above, "Jupyter: run cell + above")
  bmap("n", "<leader>jA", runner.run_all, "Jupyter: run all cells")
  bmap("n", "<leader>jl", runner.run_line, "Jupyter: run line")
  bmap("v", "<leader>jr", runner.run_range, "Jupyter: run selection")
end)

-- Renders markdown *inside the CodeCompanion chat buffer* — headings, code
-- blocks with syntax highlighting, lists, tables — so AI responses are legible
-- instead of raw markdown source.
--
-- Scoped to the "codecompanion" filetype only, so it does NOT interfere with
-- obsidian.nvim / your regular .md notes. (Add "markdown" to both lists below
-- if you ever want your normal markdown files rendered too.)
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "codecompanion" },
  opts = {
    file_types = { "codecompanion" },
  },
}

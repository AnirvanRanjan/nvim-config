return {
  "sylvanfranklin/omni-preview.nvim",
  dependencies = {
    -- for markdown
    { "toppair/peek.nvim", lazy = true, build = "deno task --quiet build:fast" },
  },
  config = function()
    require("omni-preview").setup()
    require("peek").setup({ app = "browser" })
  end,
}

return {
  {
    "CRAG666/code_runner.nvim",
    config = function()
      require("code_runner").setup({
        -- Forces the output into a floating window instead of a split
        mode = "float",
        float = {
          -- Gives it the clean LazyVim-style borders
          border = "rounded",
          -- Adjust these to change the size of the popup
          width = 0.8,
          height = 0.8,
        },
        filetype = {
          java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
          python = "/opt/homebrew/bin/python3.11 -u",
        },
      })
    end,
    keys = {
      { "<leader>r", ":RunCode<CR>", desc = "Run Code in Float" },
    },
  },
}

local plugins = {
	"michaelrommel/nvim-silicon",
	lazy = true,
	cmd = "Silicon",
	config = function()
		require("silicon").setup({
			font = "Menlo=34",
			theme = "Dracula",
			to_clipboard = true,
			background_image = "/Users/anirvanranjan/Downloads/bg.png",
			line_pad = 1, -- Increase this value to add more vertical space between lines
			num_separator = "│ ",
			window_title = function()
				return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
			end,
			output = function()
				local custom_path = vim.fn.expand("/Users/anirvanranjan/Downloads/codesc/")
				return custom_path .. os.date("!%Y-%m-%dT%H-%M-%S") .. "_code.png"
			end,
		})
	end,
}
return plugins

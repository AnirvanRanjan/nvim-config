return {
	"epwalsh/obsidian.nvim",
	version = "*", -- latest stable
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	opts = {
		workspaces = {
			{
				name = "personal",
				path = "/Users/anirvanranjan/Downloads/comeback",
			},
		},
		completion = {
			nvim_cmp = false,
		},
		note_id_func = function(title)
			if title ~= nil then
				return title:gsub(" ", "-"):lower()
			else
				return tostring(os.time())
			end
		end,
		ui = {
			enable = true, -- set to false to disable UI enhancements
		},
	},
}

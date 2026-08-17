return {
	{
		"willothy/nvim-cokeline", -- Plugin name
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for v0.4.0+
			"nvim-tree/nvim-web-devicons", -- If you want devicons
			"stevearc/resession.nvim", -- Optional, for persistent history
		},
		config = true, -- Load the plugin's configuration
	},
}
--   {
-- 	"akinsho/bufferline.nvim",
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- 	version = "*",
-- 	opts = {
-- 		options = {
-- 			mode = "tabs",
-- 			separator_style = "slant",
-- 		},
-- 	},
-- }

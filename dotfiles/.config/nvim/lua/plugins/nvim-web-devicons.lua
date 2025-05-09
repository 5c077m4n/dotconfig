---@module 'lazy'
---@type LazyPluginSpec
return {
	"nvim-tree/nvim-web-devicons",
	event = { "VeryLazy" },
	lazy = true,
	config = function()
		require("nvim-web-devicons").setup({
			override_by_extension = {
				fish = { icon = "󰈺", name = "Fish", color = "#89cff0" },
			},
		})
	end,
}

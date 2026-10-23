---@module 'lazy'
---@type LazyPluginSpec
return {
	"Tim4c/tuios-nvim-navigator",
	event = { "VeryLazy" },
	config = function()
		require("tuios-nvim-navigator").setup({
			keymaps = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
		})
	end,
}

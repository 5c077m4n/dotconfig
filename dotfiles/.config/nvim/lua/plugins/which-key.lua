---@module 'lazy'
---@type LazyPluginSpec
return {
	"folke/which-key.nvim",
	event = { "VeryLazy" },
	opts = {
		plugins = { marks = false, registers = false },
	},
}

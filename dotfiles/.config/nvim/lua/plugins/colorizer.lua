---@module 'lazy'
---@type LazyPluginSpec
return {
	"norcalli/nvim-colorizer.lua",
	event = { "VeryLazy" },
	config = function() require("colorizer").setup() end,
}

---@module 'lazy'
---@type LazyPluginSpec
return {
	"onsails/lspkind-nvim",
	event = { "VeryLazy" },
	config = function() require("lspkind").init({ mode = "text" }) end,
}

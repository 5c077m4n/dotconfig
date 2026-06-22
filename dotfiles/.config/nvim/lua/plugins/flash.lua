---@module 'lazy'
---@type LazyPluginSpec
return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
	keys = function()
		local flash = require("flash")

		return {
			{
				"<C-f><C-f>",
				mode = { "n", "x", "o" },
				function()
					flash.jump({ search = { mode = function(str) return "\\<" .. str end } })
				end,
				desc = "Flash",
			},
			{
				"<C-f><C-s>",
				mode = { "n", "x", "o" },
				function() flash.treesitter() end,
				desc = "Flash Treesitter",
			},
			{ "r", mode = "o", function() flash.remote() end, desc = "Remote Flash" },
			{
				"R",
				mode = { "o", "x" },
				function() flash.treesitter_search() end,
				desc = "Treesitter Search",
			},
			{
				"<C-s>",
				mode = { "c" },
				function() flash.toggle() end,
				desc = "Toggle Flash Search",
			},
		}
	end,
}

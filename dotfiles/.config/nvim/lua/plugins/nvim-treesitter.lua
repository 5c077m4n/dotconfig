---@module 'lazy'
---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-treesitter").install({
			"vim",
			"vimdoc",
			"lua",
			"c",
			"bash",
			"html",
			"css",
			"markdown",
			"javascript",
			"typescript",
			"python",
			"rust",
			"go",
			"zig",
			"terraform",
		})
	end,
}

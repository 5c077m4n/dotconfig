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
			"vue",
			"markdown",
			"javascript",
			"typescript",
			"tsx",
			"sql",
			"python",
			"rust",
			"go",
			"zig",
			"terraform",
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
			callback = function(args) pcall(vim.treesitter.start, args.buf) end,
		})
	end,
}

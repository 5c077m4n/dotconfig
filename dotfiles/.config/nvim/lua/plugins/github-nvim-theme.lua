---@module 'lazy'
---@type LazyPluginSpec
return {
	"projekt0n/github-nvim-theme",
	init = function() vim.cmd.colorscheme("github_dark_colorblind") end,
	config = function()
		require("github-theme").setup({
			options = { dim_inactive = true },
		})
	end,
	priority = 1000,
}

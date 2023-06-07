return {
	'projekt0n/github-nvim-theme',
	config = function()
		require('github-theme').setup({
			options = { dim_inactive = true },
		})
		vim.cmd.colorscheme('github_dark_colorblind')
	end,
}

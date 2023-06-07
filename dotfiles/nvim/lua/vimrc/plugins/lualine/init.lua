return {
	'nvim-lualine/lualine.nvim',
	after = 'github-nvim-theme',
	requires = {
		'SmiteshP/nvim-navic',
		{ 'nvim-tree/nvim-web-devicons', opt = true },
	},
	config = function()
		vim.cmd.packadd('nvim-web-devicons')
		require('vimrc.plugins.lualine.config')
	end,
}

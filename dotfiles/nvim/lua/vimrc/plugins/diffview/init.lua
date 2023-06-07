return {
	'sindrets/diffview.nvim',
	requires = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-tree/nvim-web-devicons', opt = true },
	},
	config = function()
		vim.cmd.packadd('nvim-web-devicons')
		require('vimrc.plugins.diffview.config')
	end,
	disable = true,
}

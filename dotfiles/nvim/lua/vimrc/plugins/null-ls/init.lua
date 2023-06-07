return {
	'jose-elias-alvarez/null-ls.nvim',
	requires = 'nvim-lua/plenary.nvim',
	config = function()
		require('vimrc.plugins.null-ls.config')
	end,
}

return {
	'neovim/nvim-lspconfig',
	after = { 'mason.nvim', 'mason-lspconfig.nvim' },
	config = function()
		require('vimrc.plugins.lspconfig.config').setup()
	end,
}

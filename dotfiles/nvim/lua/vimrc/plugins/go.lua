return {
	'ray-x/go.nvim',
	requires = { 'neovim/nvim-lspconfig', 'nvim-treesitter/nvim-treesitter' },
	config = function()
		require('go').setup()
	end,
}

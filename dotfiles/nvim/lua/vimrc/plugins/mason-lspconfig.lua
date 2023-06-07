return {
	'williamboman/mason-lspconfig.nvim',
	requires = { 'neovim/nvim-lspconfig' },
	after = 'mason.nvim',
	config = function()
		require('mason-lspconfig').setup({
			ensure_installed = require('vimrc.plugins.lspconfig').SERVER_LIST,
			automatic_installation = true,
		})
	end,
}

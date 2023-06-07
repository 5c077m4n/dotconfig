return {
	'hrsh7th/nvim-cmp',
	requires = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		{
			'L3MON4D3/LuaSnip',
			tag = 'v1.*',
			run = 'make install_jsregexp',
			requires = { 'saadparwaiz1/cmp_luasnip' },
		},
		'hrsh7th/cmp-calc',
		'f3fora/cmp-spell',
		'onsails/lspkind-nvim',
	},
	config = function()
		require('vimrc.plugins.cmp.config')
	end,
}

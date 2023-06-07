return {
	'nvim-telescope/telescope-fzf-native.nvim',
	after = 'telescope.nvim',
	requires = { 'nvim-telescope/telescope.nvim' },
	run = 'make',
	config = function()
		require('telescope').load_extension('fzf')
	end,
}

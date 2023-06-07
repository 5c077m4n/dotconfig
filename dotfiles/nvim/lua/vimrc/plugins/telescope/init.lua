return {
	'nvim-telescope/telescope.nvim',
	requires = {
		'nvim-lua/popup.nvim',
		'nvim-lua/plenary.nvim',
		'sharkdp/fd',
		'BurntSushi/ripgrep',
	},
	config = function()
		require('vimrc.plugins.telescope.config')
		require('vimrc.plugins.telescope.commands')
	end,
}

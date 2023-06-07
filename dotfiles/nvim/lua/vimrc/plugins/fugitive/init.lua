return {
	'tpope/vim-fugitive',
	event = { 'VimEnter', 'WinEnter', 'BufWinEnter' },
	config = function()
		require('vimrc.plugins.fugitive.config')
	end,
}

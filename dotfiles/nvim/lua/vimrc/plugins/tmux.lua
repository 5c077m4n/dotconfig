return {
	'aserowy/tmux.nvim',
	config = function()
		require('tmux').setup({
			resize = { enable_default_keybindings = false },
		})
	end,
}

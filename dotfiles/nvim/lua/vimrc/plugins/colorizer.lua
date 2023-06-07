return {
	'norcalli/nvim-colorizer.lua',
	events = { 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' },
	config = function()
		require('colorizer').setup()
	end,
}

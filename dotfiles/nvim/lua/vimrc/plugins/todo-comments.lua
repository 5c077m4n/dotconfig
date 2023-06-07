return {
	'folke/todo-comments.nvim',
	events = { 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' },
	config = function()
		require('todo-comments').setup()
	end,
}

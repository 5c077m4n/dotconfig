return {
	'phaazon/hop.nvim',
	event = { 'FocusGained', 'BufEnter' },
	config = function()
		local hop = require('hop')
		local directions = require('hop.hint').HintDirection

		local keymap = require('vimrc.utils.keymapping')

		hop.setup({ keys = 'etovxqpdygfblzhckisuran' })
		keymap.nvnoremap('<C-f>', hop.hint_words)
		keymap.nvnoremap('f', function()
			hop.hint_char1({
				direction = directions.AFTER_CURSOR,
				current_line_only = true,
			})
		end)
		keymap.nvnoremap('F', function()
			hop.hint_char1({
				direction = directions.BEFORE_CURSOR,
				current_line_only = true,
			})
		end)
		keymap.nvnoremap('t', function()
			hop.hint_char1({
				direction = directions.AFTER_CURSOR,
				current_line_only = true,
				hint_offset = -1,
			})
		end)
		keymap.nvnoremap('T', function()
			hop.hint_char1({
				direction = directions.BEFORE_CURSOR,
				current_line_only = true,
				hint_offset = 1,
			})
		end)
	end,
}

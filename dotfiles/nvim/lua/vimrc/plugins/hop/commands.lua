local hop = require('hop')
local hop_hint = require('hop.hint')

local keymap = require('vimrc.utils.keymapping')

keymap.nnoremap('f', function()
	hop.hint_char1({ direction = hop_hint.HintDirection.AFTER_CURSOR, current_line_only = true })
end)
keymap.nnoremap('F', hop.hint_words)

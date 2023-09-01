local gitsigns = require('gitsigns')
local gitsigns_actions = require('gitsigns.actions')

local keymap = require('vimrc.utils.keymapping')

gitsigns.setup({
	signs = {
		add = {
			hl = 'GitSignsAdd',
			text = '+',
			numhl = 'GitSignsAddNr',
			linehl = 'GitSignsAddLn',
		},
		change = {
			hl = 'GitSignsChange',
			text = '│',
			numhl = 'GitSignsChangeNr',
			linehl = 'GitSignsChangeLn',
		},
		delete = {
			hl = 'GitSignsDelete',
			text = '_',
			numhl = 'GitSignsDeleteNr',
			linehl = 'GitSignsDeleteLn',
		},
		topdelete = {
			hl = 'GitSignsDelete',
			text = '‾',
			numhl = 'GitSignsDeleteNr',
			linehl = 'GitSignsDeleteLn',
		},
		changedelete = {
			hl = 'GitSignsChange',
			text = '~',
			numhl = 'GitSignsChangeNr',
			linehl = 'GitSignsChangeLn',
		},
	},
	watch_gitdir = { interval = 800, follow_files = true },
	update_debounce = 400,
	on_attach = function(buffer_num)
		keymap.nnoremap('<leader>hr', gitsigns.reset_hunk, { buffer = buffer_num, desc = 'Reset current hunk' })
		keymap.vnoremap('<leader>hr', function()
			gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
		end, { buffer = buffer_num, desc = 'Reset selected hunk' })
		keymap.nnoremap('<leader>hR', gitsigns.reset_buffer, { buffer = buffer_num, desc = 'Reset entire buffer' })
		keymap.nnoremap('<leader>hs', gitsigns.stage_hunk, { buffer = buffer_num, desc = 'Git add current hunk' })
		keymap.nnoremap('<leader>hS', gitsigns.stage_buffer, { buffer = buffer_num, desc = 'Git add entire buffer' })
		keymap.nnoremap('<leader>hp', gitsigns.preview_hunk, { buffer = buffer_num, desc = 'Preview hunk' })
		keymap.nnoremap('<leader>h[', gitsigns_actions.prev_hunk, { buffer = buffer_num, desc = 'Go to previous hunk' })
		keymap.nnoremap('<leader>h]', gitsigns_actions.next_hunk, { buffer = buffer_num, desc = 'Go to next hunk' })
		keymap.nnoremap('<leader>hb', function()
			gitsigns.blame_line({ full = true })
		end, { buffer = buffer_num, desc = 'Git blame current hunk' })
	end,
})

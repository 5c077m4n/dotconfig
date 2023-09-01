local telescope = require('telescope')
local actions = require('telescope.actions')
local telescope_config = require('telescope.config')
local trouble = require('trouble.providers.telescope')

local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
table.insert(vimgrep_arguments, '--hidden')
table.insert(vimgrep_arguments, '--glob')
table.insert(vimgrep_arguments, '!**/.git/*')

telescope.setup({
	defaults = {
		vimgrep_arguments = vimgrep_arguments,
		mappings = {
			i = {
				['<C-k>'] = actions.cycle_history_next,
				['<C-j>'] = actions.cycle_history_prev,
				['<C-h>'] = actions.select_horizontal,
				['<C-v>'] = actions.select_vertical,
				['<C-t>'] = actions.select_tab,
				['<C-x>'] = trouble.open_with_trouble,
			},
			n = {
				['<C-k>'] = actions.cycle_history_next,
				['<C-j>'] = actions.cycle_history_prev,
				['<C-[>'] = actions.close,
				['<C-h>'] = actions.select_horizontal,
				['<C-v>'] = actions.select_vertical,
				['<C-t>'] = actions.select_tab,
				['<C-x>'] = trouble.open_with_trouble,
			},
		},
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = false,
			override_file_sorter = true,
			case_mode = 'smart_case',
		},
	},
})

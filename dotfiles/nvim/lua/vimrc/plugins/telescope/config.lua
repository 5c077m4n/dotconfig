local telescope = require('telescope')
local actions = require('telescope.actions')
local trouble = require('trouble.providers.telescope')

telescope.setup({
	defaults = {
		mappings = {
			i = {
				['<C-t>'] = trouble.open_with_trouble,
				['<C-k>'] = actions.cycle_history_next,
				['<C-j>'] = actions.cycle_history_prev,
				['<C-h>'] = actions.select_horizontal,
				['<C-v>'] = actions.select_vertical,
			},
			n = {
				['<C-t>'] = trouble.open_with_trouble,
				['<C-k>'] = actions.cycle_history_next,
				['<C-j>'] = actions.cycle_history_prev,
				['<C-[>'] = actions.close,
				['<C-h>'] = actions.select_horizontal,
				['<C-v>'] = actions.select_vertical,
			},
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
telescope.load_extension('fzf')

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
			},
			n = {
				['<C-t>'] = trouble.open_with_trouble,
				['<C-k>'] = actions.cycle_history_next,
				['<C-j>'] = actions.cycle_history_prev,
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

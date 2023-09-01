require('neo-tree').setup({
	close_if_last_window = false,
	enable_git_status = true,
	enable_diagnostics = true,
	window = {
		position = 'left',
		width = 40,
		mappings = {
			['<CR>'] = 'open',
			['l'] = 'open',
			['<c-s>'] = 'open_split',
			['<c-v>'] = 'open_vsplit',
			['<c-t>'] = 'open_tabnew',
			['h'] = 'close_node',
			['a'] = 'add',
			['A'] = 'add_directory',
			['<del>'] = 'delete',
			['r'] = 'rename',
			['yy'] = 'copy_to_clipboard',
			['dd'] = 'cut_to_clipboard',
			['p'] = 'paste_from_clipboard',
			['vy'] = 'copy', -- takes text input for destination
			['vd'] = 'move', -- takes text input for destination
			['Q'] = 'close_window',
			['R'] = 'refresh',
		},
	},
	default_component_configs = {
		name = {
			trailing_slash = true,
			use_git_status_colors = true,
		},
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = true,
			hide_gitignored = true,
			hide_by_name = {
				'.DS_Store',
				'thumbs.db',
			},
			never_show = {
				'.DS_Store',
				'thumbs.db',
			},
		},
		follow_current_file = true,
		use_libuv_file_watcher = true,
		window = {
			mappings = {
				['<bs>'] = 'navigate_up',
				['.'] = 'set_root',
				['H'] = 'toggle_hidden',
				['/'] = 'fuzzy_finder',
				['f'] = 'filter_on_submit',
				['<esc>'] = 'clear_filter',
			},
		},
	},
})

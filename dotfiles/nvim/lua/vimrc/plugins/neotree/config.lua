vim.g.neo_tree_remove_legacy_commands = true

require("neo-tree").setup({
	close_if_last_window = true,
	enable_git_status = true,
	enable_diagnostics = true,
	open_files_do_not_replace_types = { "terminal", "trouble", "qf", "gitcommit", "gitrebase" },
	window = {
		position = "right",
		width = 40,
		mappings = {
			["<CR>"] = "open",
			["h"] = "close_node",
			["l"] = "open",
			["H"] = "open_split",
			["V"] = "open_vsplit",
			["T"] = "open_tabnew",
			["a"] = "add",
			["A"] = "add_directory",
			["<del>"] = "delete",
			["d"] = "delete",
			["r"] = "rename",
			["y"] = "copy_to_clipboard",
			["x"] = "cut_to_clipboard",
			["p"] = "paste_from_clipboard",
			["vy"] = "copy", -- takes text input for destination
			["vd"] = "move", -- takes text input for destination
			["Q"] = "close_window",
			["R"] = "refresh",
			["i"] = "show_file_details",
			["z"] = "close_all_nodes",
			["Z"] = "expand_all_nodes",
			["[h"] = "prev_git_modified",
			["]h"] = "next_git_modified",
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
			hide_dotfiles = false,
			hide_gitignored = true,
			never_show = {
				".DS_Store",
				"thumbs.db",
			},
		},
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
		window = {
			mappings = {
				["<bs>"] = "navigate_up",
				["."] = "set_root",
				[">"] = "toggle_hidden",
				["/"] = "fuzzy_finder",
				["f"] = "filter_on_submit",
				["<esc>"] = "clear_filter",
			},
		},
	},
})

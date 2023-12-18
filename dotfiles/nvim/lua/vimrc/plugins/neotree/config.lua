vim.g.neo_tree_remove_legacy_commands = true

require("neo-tree").setup({
	close_if_last_window = false,
	enable_git_status = true,
	enable_diagnostics = true,
	window = {
		position = "left",
		width = 40,
		mappings = {
			["<CR>"] = "open",
			["l"] = "open",
			["<c-h>"] = "open_split",
			["<c-v>"] = "open_vsplit",
			["<c-t>"] = "open_tabnew",
			["h"] = "close_node",
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
		hijack_netrw_behavior = "open_current",
		window = {
			mappings = {
				["<bs>"] = "navigate_up",
				["."] = "set_root",
				["H"] = "toggle_hidden",
				["/"] = "fuzzy_finder",
				["f"] = "filter_on_submit",
				["<esc>"] = "clear_filter",
			},
		},
	},
})

---@module 'lazy'
---@type LazyPluginSpec
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	init = function() vim.g.neo_tree_remove_legacy_commands = true end,
	config = function()
		local neo_tree = require("neo-tree")

		local keymap = require("vimrc.utils").keymapping

		neo_tree.setup({
			close_if_last_window = true,
			enable_git_status = true,
			enable_diagnostics = true,
			open_files_do_not_replace_types = {
				"terminal",
				"trouble",
				"qf",
				"gitcommit",
				"gitrebase",
			},
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

		keymap.nnoremap(
			"<leader>tf",
			vim.cmd.Neotree,
			{ desc = "Focus on curren file in `neo-tree`" }
		)
		keymap.nnoremap(
			"<leader>tt",
			function() vim.cmd.Neotree("toggle") end,
			{ desc = "Toggle show of `neo-tree`" }
		)
		keymap.nnoremap(
			"<leader>tr",
			function()
				require("neo-tree.sources.filesystem.commands").refresh(
					require("neo-tree.sources.manager").get_state("filesystem")
				)
			end,
			{ desc = "Refresh `neo-tree`" }
		)
	end,
}

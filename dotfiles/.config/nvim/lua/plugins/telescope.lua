return {
	"nvim-telescope/telescope.nvim",
	event = { "VeryLazy" },
	dependencies = {
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		"sharkdp/fd",
		"BurntSushi/ripgrep",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"folke/trouble.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local telescope_actions = require("telescope.actions")
		local telescope_config = require("telescope.config")
		local telescope_builtin = require("telescope.builtin")
		local trouble_sources_telescope = require("trouble.sources.telescope")

		local utils = require("vimrc.utils")

		local keymap = utils.keymapping
		local is_git_repo = utils.misc.is_git_repo
		local get_visual_selection = utils.misc.get_visual_selection

		local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
		table.insert(vimgrep_arguments, "--hidden")
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")

		telescope.setup({
			defaults = {
				vimgrep_arguments = vimgrep_arguments,
				mappings = {
					i = {
						["<C-k>"] = telescope_actions.cycle_history_next,
						["<C-j>"] = telescope_actions.cycle_history_prev,
						["<C-h>"] = telescope_actions.select_horizontal,
						["<C-v>"] = telescope_actions.select_vertical,
						["<C-t>"] = telescope_actions.select_tab,
						["<C-x>"] = trouble_sources_telescope.open,
					},
					n = {
						["<C-k>"] = telescope_actions.cycle_history_next,
						["<C-j>"] = telescope_actions.cycle_history_prev,
						["<C-[>"] = telescope_actions.close,
						["<C-h>"] = telescope_actions.select_horizontal,
						["<C-v>"] = telescope_actions.select_vertical,
						["<C-t>"] = telescope_actions.select_tab,
						["<C-x>"] = trouble_sources_telescope.open,
					},
				},
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
			extensions = { fzf = {} },
		})
		telescope.load_extension("fzf")

		keymap.nnoremap("<leader>fls", function()
			if is_git_repo() then
				telescope_builtin.git_files()
			else
				telescope_builtin.find_files()
			end
		end, { desc = "Find project files" })
		keymap.nnoremap(
			"<C-p>",
			function() telescope_builtin.find_files({ cwd = vim.fn.getcwd() }) end,
			{ desc = "Find project files (from current work directory)" }
		)
		keymap.nnoremap(
			"<leader>fs",
			function() telescope_builtin.live_grep({ cwd = vim.fn.getcwd() }) end,
			{ desc = "Search project for a string (from current work directory)" }
		)
		keymap.vnoremap(
			"<leader>fs",
			function() telescope_builtin.grep_string({ cwd = vim.fn.getcwd() }) end,
			{ desc = "Search project for the current selection (from current work directory)" }
		)
		keymap.nnoremap("<leader>f:", telescope_builtin.commands, { desc = "Search commands" })
		keymap.nnoremap("<leader>fr", telescope_builtin.registers, { desc = "Search registers" })
		keymap.inoremap("<C-r>", telescope_builtin.registers, { desc = "Search registers" })
		keymap.nnoremap("<leader>fb", telescope_builtin.buffers, { desc = "Search buffers" })
		keymap.nnoremap("<leader>fm", telescope_builtin.marks, { desc = "Search bookmarks" })
		keymap.nnoremap("<leader>fh", telescope_builtin.help_tags, { desc = "Search vim helpdocs" })
		keymap.nnoremap(
			"<leader>fd",
			telescope_builtin.diagnostics,
			{ desc = "Search diagnostics" }
		)
		keymap.nnoremap(
			"<leader>fo",
			function() telescope_builtin.oldfiles({ only_cwd = true }) end,
			{ desc = "Search recently opened files" }
		)
		keymap.nnoremap(
			"<leader>fc",
			telescope_builtin.git_commits,
			{ desc = "Search through git commits" }
		)
		keymap.nnoremap(
			"<leader>fgs",
			telescope_builtin.git_status,
			{ desc = "List git status changes" }
		)
		keymap.nnoremap(
			"<leader>fgb",
			telescope_builtin.git_branches,
			{ desc = "List git branches" }
		)
		keymap.nnoremap(
			"<leader>ffc",
			telescope_builtin.git_bcommits,
			{ desc = "Search through the current file's git commits" }
		)
		keymap.nnoremap(
			"<leader>ffs",
			telescope_builtin.current_buffer_fuzzy_find,
			{ desc = "Current file fuzzy finder" }
		)
		keymap.vnoremap("<leader>ffs", function()
			local selected_text = get_visual_selection()
			telescope_builtin.current_buffer_fuzzy_find({ default_text = selected_text })
		end, { desc = "Current selection file fuzzy finder" })
		keymap.nnoremap(
			"<leader>ffy",
			telescope_builtin.lsp_document_symbols,
			{ desc = "Current file's LSP symbols" }
		)
		keymap.nnoremap("<leader>fft", telescope_builtin.filetypes, { desc = "Change filetype" })
	end,
}

local telescope = require("telescope")
local actions = require("telescope.actions")
local telescope_config = require("telescope.config")
local trouble = require("trouble.sources.telescope")

local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
	defaults = {
		vimgrep_arguments = vimgrep_arguments,
		mappings = {
			i = {
				["<C-k>"] = actions.cycle_history_next,
				["<C-j>"] = actions.cycle_history_prev,
				["<C-h>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
				["<C-x>"] = trouble.open,
			},
			n = {
				["<C-k>"] = actions.cycle_history_next,
				["<C-j>"] = actions.cycle_history_prev,
				["<C-[>"] = actions.close,
				["<C-h>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
				["<C-x>"] = trouble.open,
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

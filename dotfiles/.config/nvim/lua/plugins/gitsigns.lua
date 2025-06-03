---@module 'lazy'
---@type LazyPluginSpec
return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local gitsigns = require("gitsigns")
		local gitsigns_actions = require("gitsigns.actions")

		local keymap = require("vimrc.utils").keymapping

		gitsigns.setup({
			watch_gitdir = { interval = 800, follow_files = true },
			update_debounce = 400,
			on_attach = function(buffer_num)
				keymap.nnoremap(
					"<leader>hr",
					gitsigns.reset_hunk,
					{ buffer = buffer_num, desc = "Reset current hunk" }
				)
				keymap.vnoremap(
					"<leader>hr",
					function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
					{ buffer = buffer_num, desc = "Reset selected hunk" }
				)
				keymap.nnoremap(
					"<leader>hR",
					gitsigns.reset_buffer,
					{ buffer = buffer_num, desc = "Reset entire buffer" }
				)
				keymap.nnoremap(
					"<leader>hs",
					gitsigns.stage_hunk,
					{ buffer = buffer_num, desc = "Git add current hunk" }
				)
				keymap.nnoremap(
					"<leader>hS",
					gitsigns.stage_buffer,
					{ buffer = buffer_num, desc = "Git add entire buffer" }
				)
				keymap.nnoremap(
					"<leader>hp",
					gitsigns.preview_hunk,
					{ buffer = buffer_num, desc = "Preview hunk" }
				)
				keymap.nnoremap(
					"<leader>hb",
					function() gitsigns.blame_line({ full = true }) end,
					{ buffer = buffer_num, desc = "Git blame current hunk" }
				)
				keymap.nnoremap(
					"[h",
					function() gitsigns_actions.nav_hunk("prev") end,
					{ buffer = buffer_num, desc = "Go to previous hunk" }
				)
				keymap.nnoremap(
					"]h",
					function() gitsigns_actions.nav_hunk("next") end,
					{ buffer = buffer_num, desc = "Go to next hunk" }
				)
				keymap.nnoremap(
					"[H",
					function() gitsigns_actions.nav_hunk("first") end,
					{ buffer = buffer_num, desc = "Go to first hunk" }
				)
				keymap.nnoremap(
					"]H",
					function() gitsigns_actions.nav_hunk("last") end,
					{ buffer = buffer_num, desc = "Go to last hunk" }
				)
			end,
			preview_config = { border = "rounded" },
		})
	end,
}

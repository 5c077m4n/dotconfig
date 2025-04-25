local MAX_FILE_SIZE = 100 * 1024 -- 100KB

return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = function()
		local tree_updater = require("nvim-treesitter.install").update({ with_sync = true })
		tree_updater()
	end,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"javascript",
				"typescript",
				"css",
				"html",
				"json",
				"jsdoc",
				"rust",
				"graphql",
				"regex",
				"tsx",
				"python",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"yaml",
				"lua",
				"bash",
				"vimdoc",
				"git_config",
				"ssh_config",
				"gleam",
			},
			highlight = {
				enable = true,
				disable = function(_lang, buf_num)
					local buf_name = vim.api.nvim_buf_get_name(buf_num)
					local ok, status = pcall(vim.loop.fs_stat, buf_name)

					return ok and status and status.size > MAX_FILE_SIZE
				end,
			},
			indent = { enable = true },
			additional_vim_regex_highlighting = false,
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "]v",
					node_incremental = "]v",
					node_decremental = "[v",
					scope_incremental = false,
				},
			},
		})
	end,
}

--# selene: allow(mixed_table)

local utils = require("vimrc.utils")

local keymap = utils.keymapping

local function bootstrap()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
end

local function setup()
	bootstrap()

	require("lazy").setup({
		{ "nvim-lua/plenary.nvim", lazy = true },
		{
			"aserowy/tmux.nvim",
			event = { "VeryLazy" },
			config = function()
				require("tmux").setup({
					resize = { enable_default_keybindings = false },
				})
			end,
		},
		{
			"rcarriga/nvim-notify",
			event = { "VeryLazy" },
			config = function()
				local notify = require("notify")

				notify.setup({ stages = "slide", render = "compact", fps = 60 })
				vim.notify = notify
			end,
		},
		{
			"nvim-tree/nvim-web-devicons",
			event = { "VeryLazy" },
			config = function()
				require("nvim-web-devicons").setup({
					override_by_extension = {
						fish = { icon = "󰈺", name = "Fish", color = "#89cff0" },
					},
				})
			end,
		},
		{
			"projekt0n/github-nvim-theme",
			init = function()
				vim.cmd.colorscheme("github_dark_colorblind")
			end,
			config = function()
				require("github-theme").setup({ options = { dim_inactive = true } })
			end,
			priority = 1000,
		},
		{
			"nvim-lualine/lualine.nvim",
			event = { "VeryLazy" },
			dependencies = {
				"projekt0n/github-nvim-theme",
				"nvim-tree/nvim-web-devicons",
				"SmiteshP/nvim-navic",
				"linrongbin16/lsp-progress.nvim",
			},
			config = function()
				require("vimrc.plugins.lualine")
			end,
		},
		{
			"norcalli/nvim-colorizer.lua",
			event = { "VeryLazy" },
			config = function()
				require("colorizer").setup()
			end,
		},
		{
			"folke/todo-comments.nvim",
			event = { "VeryLazy" },
			config = function()
				require("todo-comments").setup()
			end,
		},
		{
			"onsails/lspkind-nvim",
			event = { "VeryLazy" },
			config = function()
				require("lspkind").init({ mode = "text" })
			end,
		},
		{
			"linrongbin16/lsp-progress.nvim",
			event = { "VeryLazy" },
			config = function()
				require("lsp-progress").setup()
			end,
		},
		{ "fladson/vim-kitty", ft = { "kitty" } },
		{ "tmux-plugins/vim-tmux", ft = { "tmux" } },
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require("vimrc.plugins.neotree")
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			event = { "BufReadPre", "BufNewFile" },
			build = function()
				local tree_updater = require("nvim-treesitter.install").update({ with_sync = true })
				tree_updater()
			end,
			config = function()
				local MAX_FILE_SIZE = 100 * 1024 -- 100KB

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
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = {
				{
					"williamboman/mason.nvim",
					event = { "VeryLazy" },
					build = function()
						vim.cmd.MasonUpdate()
					end,
					config = function()
						require("mason").setup({ ui = { border = "single" } })
					end,
				},
			},
			event = { "VeryLazy" },
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = require("vimrc.plugins.lspconfig").SERVER_LIST,
					automatic_installation = true,
				})
			end,
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
			config = function()
				require("vimrc.plugins.lspconfig").setup()
			end,
		},
		{ "b0o/schemastore.nvim", ft = { "json", "jsonc", "yaml" } },
		{ "ziglang/zig.vim", ft = { "zig" } },
		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			event = { "VeryLazy" },
			config = function()
				require("trouble").setup({
					fold_open = "v",
					fold_closed = ">",
					indent_lines = true,
					signs = { error = "E", warning = "W", hint = "H", information = "I" },
				})

				keymap.nnoremap("<leader>xx", function()
					vim.cmd.Trouble("diagnostics toggle")
				end, { desc = "Toggle trouble diagnostics" })
				keymap.nnoremap("<leader>xd", function()
					vim.cmd.Trouble("diagnostics toggle filter.buf=0")
				end, { desc = "Toggle trouble diagnostics for current buffer" })
				keymap.nnoremap("<leader>xl", function()
					vim.cmd.Trouble("lsp toggle")
				end, { desc = "Toggle LSP definitions & refernces" })
			end,
		},
		{
			"folke/persistence.nvim",
			event = { "VeryLazy" },
			config = function()
				local persist = require("persistence")

				persist.setup({
					pre_save = function()
						vim.cmd.Neotree("close")
					end,
					pre_load = function()
						vim.cmd.Neotree("close")
					end,
				})
				keymap.nnoremap(
					"<leader>pr",
					persist.load,
					{ desc = "Restore the session for the current directory" }
				)
				keymap.nnoremap("<leader>pl", function()
					persist.load({ last = true })
				end, { desc = "Restore the last session" })
				keymap.nnoremap("<leader>pd", function()
					persist.stop()
					vim.notify("Auto session save disabled")
				end, { desc = "Disable session save on exit" })
			end,
		},
		{
			"folke/neodev.nvim",
			dependencies = { "folke/neoconf.nvim" },
			event = { "VeryLazy" },
		},
		{
			"zeioth/garbage-day.nvim",
			dependencies = { "neovim/nvim-lspconfig" },
			event = "VeryLazy",
			opts = { aggressive_mode = true, wakeup_delay = 250 },
		},
		{
			"nvimtools/none-ls.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			event = { "InsertEnter" },
			config = function()
				require("vimrc.plugins.null-ls")
			end,
		},
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			version = "v0.*",
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				keymap = {
					preset = "default",
					["<CR>"] = { "accept", "fallback" },

					cmdline = {
						preset = "default",
					},
				},
				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},
				completion = {
					menu = {
						enabled = true,
						border = "single",
					},
					documentation = {
						auto_show = true,
						window = {
							border = "single",
						},
					},
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				signature = {
					enabled = false,
					window = { border = "single" },
				},
			},
			opts_extend = { "sources.default" },
		},
		{
			"phaazon/hop.nvim",
			event = { "FocusGained", "BufEnter" },
			config = function()
				local hop = require("hop")

				hop.setup({ keys = "etovxqpdygfblzhckisuran" })
				keymap.nvnoremap("<C-f>", hop.hint_words)
			end,
		},
		{
			"folke/which-key.nvim",
			event = { "VeryLazy" },
			opts = {
				plugins = { marks = false, registers = false },
			},
		},
		{
			"kylechui/nvim-surround",
			event = { "VeryLazy", "InsertEnter" },
			version = "*",
			opts = {},
		},
		{
			"windwp/nvim-autopairs",
			event = { "VeryLazy", "InsertEnter" },
			config = function()
				require("nvim-autopairs").setup({ check_ts = true })

				local ok, cmp = pcall(require, "cmp")
				if ok then
					local cmp_autopairs = require("nvim-autopairs.completion.cmp")
					cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end
			end,
		},
		{
			"windwp/nvim-ts-autotag",
			event = { "VeryLazy", "InsertEnter" },
			config = function()
				require("nvim-ts-autotag").setup({
					filetypes = {
						"html",
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
						"markdown",
					},
				})
			end,
		},
		{
			"tpope/vim-fugitive",
			event = { "VeryLazy" },
			config = function()
				require("vimrc.plugins.git-fugitive")
			end,
		},
		{
			"sindrets/diffview.nvim",
			event = { "VeryLazy" },
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("vimrc.plugins.diffview")
			end,
			enabled = false,
		},
		{
			"lewis6991/gitsigns.nvim",
			event = { "BufReadPre", "BufNewFile" },
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("vimrc.plugins.gitsigns")
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			event = { "VeryLazy" },
			dependencies = {
				"nvim-lua/popup.nvim",
				"nvim-lua/plenary.nvim",
				"sharkdp/fd",
				"BurntSushi/ripgrep",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			},
			config = function()
				require("vimrc.plugins.telescope")
			end,
		},
	}, { ui = { border = "single" } })
end

return { setup = setup }

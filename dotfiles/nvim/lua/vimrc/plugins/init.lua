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
			lazy = true,
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
			"samodostal/image.nvim",
			event = { "VeryLazy" },
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("image").setup({
					render = {
						min_padding = 5,
						show_label = true,
						_dither = true,
					},
					events = { update_on_nvim_resize = true },
				})
			end,
		},
		{
			"nvim-tree/nvim-web-devicons",
			event = { "VeryLazy" },
			lazy = true,
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
			lazy = true,
			config = function()
				require("colorizer").setup()
			end,
		},
		{
			"folke/todo-comments.nvim",
			event = { "VeryLazy" },
			lazy = true,
			config = function()
				require("todo-comments").setup()
			end,
		},
		{
			"onsails/lspkind-nvim",
			lazy = true,
			config = function()
				require("lspkind").init({ mode = "text" })
			end,
		},
		{
			"linrongbin16/lsp-progress.nvim",
			event = { "VeryLazy" },
			lazy = true,
			config = function()
				require("lsp-progress").setup()
			end,
		},
		{ "fladson/vim-kitty", ft = { "kitty" }, event = { "VeryLazy" }, lazy = true },
		{ "tmux-plugins/vim-tmux", ft = { "tmux" }, event = { "VeryLazy" }, lazy = true },
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
				vim.cmd.TSUpdate()
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
					},
					highlight = {
						enable = true,
						disable = function(_lang, buf)
							local ok, status =
								pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
							return ok and status and status.size > MAX_FILE_SIZE
						end,
					},
					indent = { enable = true },
					additional_vim_regex_highlighting = false,
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "vO",
							node_incremental = "vO",
							node_decremental = "vo",
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
					lazy = true,
					build = function()
						vim.cmd.MasonUpdate()
					end,
					config = function()
						require("mason").setup({ ui = { border = "single" } })
					end,
				},
			},
			event = { "VeryLazy" },
			lazy = true,
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
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			event = { "BufEnter" },
			lazy = true,
			config = function()
				local lspconfig = require("lspconfig")
				local ts_tools = require("typescript-tools")
				local ts_tools_api = require("typescript-tools.api")

				if vim.fn.executable("node") ~= 1 then
					vim.notify(
						"The `node` executable is not installed",
						vim.log.levels.ERROR,
						{ title = "typescript-tools.nvim" }
					)
				end

				ts_tools.setup({
					settings = {
						jsx_close_tag = { enable = false },
						tsserver_file_preferences = {
							includeInlayParameterNameHints = "all",
							includeCompletionsForModuleExports = true,
							quotePreference = "auto",
						},
					},
					single_file_support = false,
					root_dir = lspconfig.util.root_pattern(
						"package.json",
						"tsconfig.json",
						"package-lock.json",
						"yarn.lock",
						"pnpm-lock.yaml"
					),
					handlers = {
						["textDocument/publishDiagnostics"] = ts_tools_api.filter_diagnostics({
							80001, -- Ignore the 'File is a CommonJS module; it may be converted to an ES module.' diagnostic.
						}),
					},
				})
			end,
		},
		{ "b0o/schemastore.nvim", ft = { "json", "jsonc", "yaml" }, event = { "VeryLazy" } },
		{
			"mrcjkb/rustaceanvim",
			version = "^4",
			ft = { "rust" },
			event = { "VeryLazy" },
			init = function()
				vim.g.rustaceanvim = {
					server = {
						default_settings = {
							["rust-analyzer"] = {
								imports = {
									granularity = { group = "module" },
									prefix = "self",
								},
								cargo = {
									buildScripts = { enable = true },
								},
								procMacro = { enable = true },
							},
						},
					},
				}
			end,
		},
		{
			"folke/trouble.nvim",
			event = { "VeryLazy" },
			lazy = true,
			dependencies = { "nvim-tree/nvim-web-devicons" },
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
			lazy = true,
		},
		{
			"zeioth/garbage-day.nvim",
			dependencies = { "neovim/nvim-lspconfig" },
			event = "VeryLazy",
			opts = {},
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
			"hrsh7th/nvim-cmp",
			event = { "InsertEnter", "CmdlineEnter" },
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				{
					"L3MON4D3/LuaSnip",
					event = { "InsertEnter" },
					version = "v2.*",
					build = "make install_jsregexp",
					dependencies = { "saadparwaiz1/cmp_luasnip" },
				},
				"hrsh7th/cmp-calc",
				"f3fora/cmp-spell",
				"onsails/lspkind-nvim",
			},
			config = function()
				require("vimrc.plugins.cmp")
			end,
		},
		{
			"phaazon/hop.nvim",
			event = { "FocusGained", "BufEnter" },
			lazy = true,
			config = function()
				local hop = require("hop")

				hop.setup({ keys = "etovxqpdygfblzhckisuran" })
				keymap.nvnoremap("<C-f>", hop.hint_words)
			end,
		},
		{
			"folke/which-key.nvim",
			event = { "VeryLazy" },
			lazy = true,
			opts = {
				plugins = { marks = false, registers = false },
			},
		},
		{
			"kylechui/nvim-surround",
			event = { "VeryLazy", "InsertEnter" },
			lazy = true,
			version = "*",
			opts = {},
		},
		{
			"windwp/nvim-autopairs",
			event = { "VeryLazy", "InsertEnter" },
			lazy = true,
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
			lazy = true,
			config = function()
				require("nvim-ts-autotag").setup({
					filetypes = {
						"html",
						"javascript",
						"javascript.tsx",
						"typescript",
						"typescript.tsx",
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
			lazy = true,
			config = function()
				require("vimrc.plugins.git-fugitive")
			end,
		},
		{
			"sindrets/diffview.nvim",
			event = { "VeryLazy" },
			lazy = true,
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
			lazy = true,
			dependencies = {
				"nvim-lua/popup.nvim",
				"nvim-lua/plenary.nvim",
				"sharkdp/fd",
				"BurntSushi/ripgrep",
			},
			config = function()
				require("vimrc.plugins.telescope")
			end,
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			dependencies = { "nvim-telescope/telescope.nvim" },
			event = { "VeryLazy" },
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
	}, { ui = { border = "single" } })
end

return { setup = setup }

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
				"SmiteshP/nvim-navic",
				"nvim-tree/nvim-web-devicons",
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
				require("lspkind").init({ mode = "text" }) -- Icons in autocomplete popup
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
					},
					single_file_support = false,
					root_dir = lspconfig.util.root_pattern(
						"package.json",
						"tsconfig.json",
						"package-lock.json",
						"yarn.lock",
						"pnpm.lock"
					),
					handlers = {
						["textDocument/publishDiagnostics"] = ts_tools_api.filter_diagnostics({
							80001, -- Ignore the 'File is a CommonJS module; it may be converted to an ES module.' diagnostic.
						}),
					},
				})
			end,
		},
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
			"mfussenegger/nvim-jdtls",
			event = { "VeryLazy" },
			ft = { "java" },
			dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
			config = function()
				local jdtls = require("jdtls")
				local mason_registry = require("mason-registry")

				local jdtls_install_dir = mason_registry.get_package("jdtls"):get_install_path()

				local platform_config
				if vim.fn.has("mac") == 1 then
					platform_config = jdtls_install_dir .. "/config_mac_arm"
				elseif vim.fn.has("unix") == 1 then
					platform_config = jdtls_install_dir .. "/config_linux"
				elseif vim.fn.has("win32") == 1 then
					platform_config = jdtls_install_dir .. "/config_win"
				end

				jdtls.start_or_attach({
					cmd = {
						"java",
						"-jar",
						vim.fn.glob(
							jdtls_install_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar"
						),
						"-configuration",
						platform_config,
					},
					root_dir = jdtls.setup.find_root({ "gradlew", ".git", "mvnw" }),
				})
			end,
			cond = false,
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

				keymap.nnoremap(
					"<leader>xx",
					vim.cmd.TroubleToggle,
					{ desc = "Toggle trouble panel" }
				)
				keymap.nnoremap("<leader>xw", function()
					vim.cmd.TroubleToggle("workspace_diagnostics")
				end, { desc = "Toggle trouble workspace diagnostics" })
				keymap.nnoremap("<leader>xd", function()
					vim.cmd.TroubleToggle("document_diagnostics")
				end, { desc = "Toggle trouble document diagnostics" })
				keymap.nnoremap("<leader>xq", function()
					vim.cmd.TroubleToggle("quickfix")
				end, { desc = "Toggle trouble quick fix panel" })
				keymap.nnoremap("<leader>xl", function()
					vim.cmd.TroubleToggle("loclist")
				end, { desc = "Toggle trouble loclist panel" })
			end,
		},
		{
			"folke/neodev.nvim",
			dependencies = { "folke/neoconf.nvim" },
			event = { "VeryLazy" },
			lazy = true,
		},
		{
			"ray-x/go.nvim",
			dependencies = { "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
			ft = { "go", "gomod", "godoc", "gotexttmpl", "gohtmltmpl" },
			event = { "CmdlineEnter" },
			lazy = true,
			build = function()
				require("go.install").update_all()
			end,
			config = function()
				local go = require("go")
				local go_lsp_config = require("go.lsp").config()
				local lspconfig = require("lspconfig")

				go.setup({
					disable_defaults = true,
					lsp_cfg = false,
					max_line_len = 100,
					lsp_inlay_hints = { enable = false },
					trouble = true,
					lsp_keymaps = false,
				})
				vim.tbl_deep_extend("force", go_lsp_config, {
					settings = {
						gopls = {
							analyses = { undparams = true },
							staticcheck = true,
						},
					},
				})
				lspconfig.gopls.setup(go_lsp_config)
			end,
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
			event = { "InsertEnter" },
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				{
					"L3MON4D3/LuaSnip",
					event = { "InsertEnter" },
					version = "v1.*",
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
				local directions = require("hop.hint").HintDirection

				hop.setup({ keys = "etovxqpdygfblzhckisuran" })
				keymap.nvnoremap("<C-f>", hop.hint_words)
				keymap.nvnoremap("f", function()
					hop.hint_char1({
						direction = directions.AFTER_CURSOR,
						current_line_only = true,
					})
				end)
				keymap.nvnoremap("F", function()
					hop.hint_char1({
						direction = directions.BEFORE_CURSOR,
						current_line_only = true,
					})
				end)
				keymap.nvnoremap("t", function()
					hop.hint_char1({
						direction = directions.AFTER_CURSOR,
						current_line_only = true,
						hint_offset = -1,
					})
				end)
				keymap.nvnoremap("T", function()
					hop.hint_char1({
						direction = directions.BEFORE_CURSOR,
						current_line_only = true,
						hint_offset = 1,
					})
				end)
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
		{ "numToStr/Comment.nvim", opts = {}, event = { "VeryLazy" }, lazy = false },
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

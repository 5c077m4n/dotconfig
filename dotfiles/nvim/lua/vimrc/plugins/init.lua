local utils = require('vimrc.utils')

local keymap = utils.keymapping

local M = {}

local function bootstrap()
	local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

	---@diagnostic disable-next-line: undefined-field
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			'git',
			'clone',
			'--filter=blob:none',
			'https://github.com/folke/lazy.nvim.git',
			'--branch=stable',
			lazypath,
		})
	end
	---@diagnostic disable-next-line: undefined-field
	vim.opt.rtp:prepend(lazypath)
end

function M.setup()
	bootstrap()

	require('lazy').setup({
		{ 'nvim-lua/plenary.nvim', lazy = true },
		{
			'aserowy/tmux.nvim',
			config = function()
				require('tmux').setup({
					resize = { enable_default_keybindings = false },
				})
			end,
		},
		{
			'rcarriga/nvim-notify',
			config = function()
				local notify = require('notify')

				notify.setup({ stages = 'slide', render = 'compact', fps = 60 })
				vim.notify = notify
			end,
		},
		{
			'samodostal/image.nvim',
			event = 'VeryLazy',
			dependencies = { 'nvim-lua/plenary.nvim' },
			config = function()
				require('image').setup({
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
			'projekt0n/github-nvim-theme',
			config = function()
				require('github-theme').setup({
					options = { dim_inactive = true },
				})
				vim.cmd.colorscheme('github_dark_colorblind')
			end,
			priority = 1000,
		},
		{
			'nvim-lualine/lualine.nvim',
			dependencies = {
				'projekt0n/github-nvim-theme',
				'SmiteshP/nvim-navic',
				{ 'nvim-tree/nvim-web-devicons', lazy = true },
			},
			config = function()
				require('vimrc.plugins.lualine')
			end,
		},
		{
			'norcalli/nvim-colorizer.lua',
			event = 'VeryLazy',
			config = function()
				require('colorizer').setup()
			end,
		},
		{
			'folke/todo-comments.nvim',
			event = 'VeryLazy',
			config = function()
				require('todo-comments').setup()
			end,
		},
		{
			'onsails/lspkind-nvim',
			config = function()
				require('lspkind').init({ mode = 'text' }) -- Icons in autocomplete popup
			end,
		},
		{ 'fladson/vim-kitty', ft = { 'kitty' } },
		{ 'tmux-plugins/vim-tmux', ft = { 'tmux' } },
		{
			'nvim-neo-tree/neo-tree.nvim',
			branch = 'v3.x',
			dependencies = {
				'nvim-lua/plenary.nvim',
				{ 'nvim-tree/nvim-web-devicons', lazy = true },
				'MunifTanjim/nui.nvim',
			},
			config = function()
				require('vimrc.plugins.neotree')
			end,
		},
		{
			'nvim-treesitter/nvim-treesitter',
			build = function()
				vim.cmd.TSUpdate()
			end,
			config = function()
				require('nvim-treesitter.configs').setup({
					ensure_installed = {
						'javascript',
						'typescript',
						'css',
						'html',
						'json',
						'jsdoc',
						'rust',
						'graphql',
						'regex',
						'tsx',
						'python',
						'yaml',
						'lua',
						'bash',
						'vimdoc',
						'git_config',
						'ssh_config',
					},
					ignore_install = {},
					highlight = { enable = true, disable = {} },
				})
			end,
		},
		{
			'williamboman/mason.nvim',
			build = function()
				vim.cmd.MasonUpdate()
			end,
			config = function()
				require('mason').setup({
					ui = { border = 'single' },
				})
			end,
		},
		{
			'williamboman/mason-lspconfig.nvim',
			dependencies = { 'williamboman/mason.nvim' },
			config = function()
				require('mason-lspconfig').setup({
					ensure_installed = require('vimrc.plugins.lspconfig').SERVER_LIST,
					automatic_installation = true,
				})
			end,
		},
		{
			'neovim/nvim-lspconfig',
			dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
			config = function()
				require('vimrc.plugins.lspconfig').setup()
			end,
		},
		{
			'5c077m4n/typescript.nvim',
			dependencies = { 'neovim/nvim-lspconfig' },
			ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
			config = function()
				require('typescript').setup({
					go_to_source_definition = { fallback = true },
					server = {
						root_dir = require('lspconfig').util.root_pattern(
							'package.json',
							'package-lock.json',
							'tsconfig.json'
						),
						single_file_support = false,
					},
				})
			end,
		},
		{
			'simrat39/rust-tools.nvim',
			dependencies = { 'neovim/nvim-lspconfig' },
			ft = { 'rust' },
			config = function()
				local rust_tools = require('rust-tools')

				rust_tools.setup({
					tools = {
						inlay_hints = {
							auto = true,
							only_current_line = true,
						},
					},
					server = {
						on_attach = function(_client, buffer_n)
							keymap.nnoremap(
								'<leader>cA',
								rust_tools.code_action_group.code_action_group,
								{ buffer = buffer_n, desc = 'Open rust tools code actions pane' }
							)
						end,
					},
				})
			end,
		},
		{
			'folke/trouble.nvim',
			event = 'VeryLazy',
			dependencies = {
				{ 'nvim-tree/nvim-web-devicons', lazy = true },
			},
			config = function()
				require('trouble').setup({
					fold_open = 'v',
					fold_closed = '>',
					indent_lines = true,
					signs = { error = 'E', warning = 'W', hint = 'H', information = 'I' },
				})

				keymap.nnoremap('<leader>xx', vim.cmd.TroubleToggle, { desc = 'Toggle trouble panel' })
				keymap.nnoremap('<leader>xw', function()
					vim.cmd.TroubleToggle('workspace_diagnostics')
				end, { desc = 'Toggle trouble workspace diagnostics' })
				keymap.nnoremap('<leader>xd', function()
					vim.cmd.TroubleToggle('document_diagnostics')
				end, { desc = 'Toggle trouble document diagnostics' })
				keymap.nnoremap('<leader>xq', function()
					vim.cmd.TroubleToggle('quickfix')
				end, { desc = 'Toggle trouble quick fix panel' })
				keymap.nnoremap('<leader>xl', function()
					vim.cmd.TroubleToggle('loclist')
				end, { desc = 'Toggle trouble loclist panel' })
			end,
		},
		{ 'folke/neodev.nvim', ft = 'lua' },
		{
			'ray-x/go.nvim',
			dependencies = { 'neovim/nvim-lspconfig', 'nvim-treesitter/nvim-treesitter' },
			ft = { 'go', 'gomod', 'godoc', 'gotexttmpl', 'gohtmltmpl' },
			config = function()
				local go = require('go')
				local go_lsp_config = require('go.lsp').config()
				local lspconfig = require('lspconfig')

				go.setup({
					lsp_cfg = false,
					max_line_len = 100,
					lsp_inlay_hints = { enable = false },
					trouble = true,
				})
				vim.tbl_deep_extend('force', go_lsp_config, {
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
			'5c077m4n/null-ls.nvim',
			dependencies = 'nvim-lua/plenary.nvim',
			config = function()
				require('vimrc.plugins.null-ls')
			end,
		},
		{
			'hrsh7th/nvim-cmp',
			dependencies = {
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
				'hrsh7th/cmp-cmdline',
				{
					'L3MON4D3/LuaSnip',
					version = 'v1.*',
					build = 'make install_jsregexp',
					dependencies = { 'saadparwaiz1/cmp_luasnip' },
				},
				'hrsh7th/cmp-calc',
				'f3fora/cmp-spell',
				'onsails/lspkind-nvim',
			},
			config = function()
				require('vimrc.plugins.cmp')
			end,
		},
		{
			'phaazon/hop.nvim',
			event = { 'FocusGained', 'BufEnter' },
			config = function()
				local hop = require('hop')
				local directions = require('hop.hint').HintDirection

				hop.setup({ keys = 'etovxqpdygfblzhckisuran' })
				keymap.nvnoremap('<C-f>', hop.hint_words)
				keymap.nvnoremap('f', function()
					hop.hint_char1({
						direction = directions.AFTER_CURSOR,
						current_line_only = true,
					})
				end)
				keymap.nvnoremap('F', function()
					hop.hint_char1({
						direction = directions.BEFORE_CURSOR,
						current_line_only = true,
					})
				end)
				keymap.nvnoremap('t', function()
					hop.hint_char1({
						direction = directions.AFTER_CURSOR,
						current_line_only = true,
						hint_offset = -1,
					})
				end)
				keymap.nvnoremap('T', function()
					hop.hint_char1({
						direction = directions.BEFORE_CURSOR,
						current_line_only = true,
						hint_offset = 1,
					})
				end)
			end,
		},
		{
			'francoiscabrol/ranger.vim',
			event = 'VeryLazy',
			dependencies = 'rbgrouleff/bclose.vim',
			config = function()
				keymap.nnoremap('<leader>rr', vim.cmd.Ranger, { desc = 'Open ranger file browser' })
			end,
		},
		{ 'folke/which-key.nvim', event = 'VeryLazy', opts = {} },
		{ 'kylechui/nvim-surround', event = 'VeryLazy', version = '*', opts = {} },
		{
			'windwp/nvim-autopairs',
			event = 'VeryLazy',
			config = function()
				require('nvim-autopairs').setup({ check_ts = true })

				local ok, cmp = pcall(require, 'cmp')
				if ok then
					local cmp_autopairs = require('nvim-autopairs.completion.cmp')
					cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
				end
			end,
		},
		{
			'windwp/nvim-ts-autotag',
			event = 'InsertEnter',
			config = function()
				require('nvim-ts-autotag').setup({
					filetypes = {
						'html',
						'javascript',
						'javascript.tsx',
						'typescript',
						'typescript.tsx',
						'javascriptreact',
						'typescriptreact',
						'markdown',
					},
				})
			end,
		},
		{
			'terrortylor/nvim-comment',
			event = 'VeryLazy',
			config = function()
				require('nvim_comment').setup({
					marker_padding = true,
					comment_empty = false,
					create_mappings = true,
					line_mapping = '<leader>/',
					operator_mapping = '<leader>/',
				})
			end,
		},
		{
			'tpope/vim-fugitive',
			event = 'VeryLazy',
			config = function()
				require('vimrc.plugins.git-fugitive')
			end,
		},
		{
			'sindrets/diffview.nvim',
			event = 'VeryLazy',
			dependencies = {
				'nvim-lua/plenary.nvim',
				{ 'nvim-tree/nvim-web-devicons', lazy = true },
			},
			config = function()
				vim.cmd.packadd('nvim-web-devicons')
				require('vimrc.plugins.diffview')
			end,
			enabled = false,
		},
		{
			'lewis6991/gitsigns.nvim',
			dependencies = 'nvim-lua/plenary.nvim',
			config = function()
				require('vimrc.plugins.gitsigns')
			end,
		},
		{
			'nvim-telescope/telescope.nvim',
			event = 'VeryLazy',
			dependencies = {
				'nvim-lua/popup.nvim',
				'nvim-lua/plenary.nvim',
				'sharkdp/fd',
				'BurntSushi/ripgrep',
			},
			config = function()
				require('vimrc.plugins.telescope')
			end,
		},
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			dependencies = 'nvim-telescope/telescope.nvim',
			build = 'make',
			config = function()
				require('telescope').load_extension('fzf')
			end,
		},
	})
end

return M

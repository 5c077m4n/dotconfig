local M = {}

local function bootstrap()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

	---@diagnostic disable-next-line: missing-parameter
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({
			'git',
			'clone',
			'https://github.com/wbthomason/packer.nvim',
			install_path,
		})
		vim.cmd([[packadd packer.nvim]])
	end
end

local function init_packer()
	vim.cmd([[packadd packer.nvim]])

	require('packer').startup({
		function(use)
			-- General
			use('lewis6991/impatient.nvim')
			use('tpope/vim-sensible')
			use('nvim-lua/plenary.nvim')
			use({
				'rcarriga/nvim-notify',
				config = function()
					local notify = require('notify')

					notify.setup({ background_colour = '#000000' })
					vim.notify = notify
				end,
			})
			use({
				'nvim-treesitter/nvim-treesitter-context',
				requires = { 'nvim-treesitter/nvim-treesitter' },
				config = function()
					require('treesitter-context').setup({
						max_lines = 3,
						patters = {
							default = {
								'class',
								'function',
								'method',
								'for',
								'while',
								'if',
								'switch',
								'case',
							},
							rust = {
								'impl',
								'mod',
								'struct',
								'fn',
							},
							typescript = {
								'const',
								'let',
							},
						},
					})
				end,
			})
			use({
				'nathom/filetype.nvim',
				config = function()
					require('filetype').setup({
						extensions = {
							tsx = 'typescriptreact',
							jsx = 'javascriptreact',
							toml = 'toml',
						},
						literal = {
							['.babelrc'] = 'json',
							['.swcrc'] = 'json',
						},
					})
				end,
			})
			use({
				'samodostal/image.nvim',
				requires = { 'nvim-lua/plenary.nvim' },
				config = function()
					require('image').setup({
						render = {
							min_padding = 5,
							show_label = true,
							use_dither = true,
						},
						events = {
							update_on_nvim_resize = true,
						},
					})
				end,
			})
			-- Theme
			use({
				'projekt0n/github-nvim-theme',
				config = function()
					require('github-theme').setup({
						theme_style = 'dark_default',
						sidebars = { 'lazygit', 'terminal', 'packer' },
					})
				end,
			})
			use({
				'norcalli/nvim-colorizer.lua',
				config = function()
					require('colorizer').setup()
				end,
			})
			use({
				'folke/todo-comments.nvim',
				config = function()
					require('todo-comments').setup()
				end,
			})
			use({
				'feline-nvim/feline.nvim',
				requires = { 'kyazdani42/nvim-web-devicons' },
				config = function()
					local feline = require('feline')

					feline.setup({ preset = 'noicon' })
					feline.winbar.setup({
						disable = {
							filetypes = { [[^neo-tree$]] },
						},
					})
				end,
			})
			use({
				'onsails/lspkind-nvim',
				config = function()
					require('lspkind').init({ mode = 'text' }) -- Icons in autocomplete popup
				end,
				event = 'BufReadPost',
			})
			-- File tree
			use({
				'nvim-neo-tree/neo-tree.nvim',
				branch = 'v2.x',
				requires = {
					'nvim-lua/plenary.nvim',
					'kyazdani42/nvim-web-devicons',
					'MunifTanjim/nui.nvim',
				},
				config = function()
					require('vimrc.plugins.neotree')
				end,
			})
			-- Treesitter
			use({
				'nvim-treesitter/nvim-treesitter',
				config = function()
					require('vimrc.plugins.nvim-treesitter')
				end,
			})
			-- LSP
			use({
				'neovim/nvim-lspconfig',
				run = ':TSUpdate',
				config = function()
					require('vimrc.plugins.lspconfig')
				end,
			})
			use({
				'williamboman/mason-lspconfig.nvim',
				requires = 'williamboman/mason.nvim',
			})
			use({
				'folke/trouble.nvim',
				requires = 'kyazdani42/nvim-web-devicons',
				config = function()
					require('vimrc.plugins.trouble')
				end,
			})
			use('folke/neodev.nvim')
			use({
				'simrat39/rust-tools.nvim',
				requires = {
					'neovim/nvim-lspconfig',
					'nvim-lua/plenary.nvim',
					'mfussenegger/nvim-dap',
				},
				ft = { 'rust' },
				config = function()
					require('rust-tools').setup({
						tools = {
							inlay_hints = {
								auto = true,
								only_current_line = true,
							},
						},
						server = {
							settings = {
								['rust-analyzer'] = {
									assist = {
										importGranularity = 'module',
										importPrefix = 'by_self',
									},
									cargo = { loadOutDirsFromCheck = true },
									procMacro = { enable = true },
								},
							},
							on_attach = function(_, buffer_num)
								local rust_tools = require('rust-tools')
								local keymap = require('vimrc.utils.keymapping')

								keymap.nnoremap('J', rust_tools.join_lines.join_lines, { buffer = buffer_num })
								keymap.nnoremap(
									'<leader>ca',
									rust_tools.hover_actions.hover_actions,
									{ buffer = buffer_num, desc = 'Hover actions' }
								)
							end,
						},
					})
				end,
				disable = true,
			})
			use({
				'jose-elias-alvarez/null-ls.nvim',
				requires = { 'nvim-lua/plenary.nvim' },
				config = function()
					require('vimrc.plugins.null-ls')
				end,
			})
			-- Code snippets
			use({
				'hrsh7th/nvim-cmp',
				requires = {
					'hrsh7th/cmp-nvim-lsp',
					'hrsh7th/cmp-buffer',
					'hrsh7th/cmp-path',
					'hrsh7th/cmp-cmdline',
					'hrsh7th/cmp-vsnip',
					'hrsh7th/vim-vsnip',
					'hrsh7th/cmp-calc',
					'f3fora/cmp-spell',
				},
				config = function()
					require('vimrc.plugins.cmp')
				end,
			})
			-- Terminal
			use({
				'akinsho/toggleterm.nvim',
				tag = 'v2.*',
				config = function()
					require('toggleterm').setup({
						size = function(term)
							if term.direction == 'horizontal' then
								return vim.o.lines * 0.4
							elseif term.direction == 'vertical' then
								return vim.o.columns * 0.4
							end
						end,
						open_mapping = [[<F12>]],
						hide_numbers = false,
						insert_mappings = true,
						terminal_mappings = true,
					})
				end,
			})
			-- Code workflow
			use({
				'phaazon/hop.nvim',
				as = 'hop',
				keys = { 'F' },
				config = function()
					require('vimrc.plugins.hop')
				end,
			})
			use({
				'francoiscabrol/ranger.vim',
				requires = 'rbgrouleff/bclose.vim',
				config = function()
					require('vimrc.plugins.ranger')
				end,
			})
			use({
				'folke/which-key.nvim',
				config = function()
					require('which-key').setup({
						plugins = {
							marks = true,
							registers = true,
							spelling = { enabled = false, suggestions = 20 },
						},
					})
				end,
			})
			use({
				'kylechui/nvim-surround',
				tag = '*',
				config = function()
					require('nvim-surround').setup({})
				end,
			})
			use({
				'windwp/nvim-autopairs',
				event = 'InsertEnter',
				config = function()
					require('nvim-autopairs').setup()

					local cmp_autopairs = require('nvim-autopairs.completion.cmp')
					local cmp = require('cmp')

					cmp.event:on(
						'confirm_done',
						cmp_autopairs.on_confirm_done({
							map_char = { tex = '' },
						})
					)
				end,
			})
			use({
				'terrortylor/nvim-comment',
				config = function()
					require('vimrc.plugins.nvim-comment')
				end,
			})
			-- Git
			use({
				'tpope/vim-fugitive',
				config = function()
					require('vimrc.plugins.git-fugitive')
				end,
			})
			use({
				'sindrets/diffview.nvim',
				requires = {
					'nvim-lua/plenary.nvim',
					{ 'kyazdani42/nvim-web-devicons', opt = true },
				},
				config = function()
					require('vimrc.plugins.diffview')
				end,
				disable = true,
			})
			use({ 'kdheepak/lazygit.nvim', cmd = 'LazyGit', branch = 'main' })
			use({
				'lewis6991/gitsigns.nvim',
				requires = 'nvim-lua/plenary.nvim',
				config = function()
					require('vimrc.plugins.gitsigns')
				end,
			})
			-- Telescope
			use({
				'nvim-telescope/telescope.nvim',
				requires = {
					'nvim-lua/popup.nvim',
					'nvim-lua/plenary.nvim',
					'sharkdp/fd',
					'BurntSushi/ripgrep',
				},
				config = function()
					require('vimrc.plugins.telescope')
				end,
			})
			use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
			-- Session
			use({
				'rmagatti/auto-session',
				config = function()
					require('vimrc.plugins.auto-session')
				end,
				disable = true,
			})
			-- Debugging
			use({ 'nvim-telescope/telescope-dap.nvim', disable = true })
			use({ 'mfussenegger/nvim-dap', ft = { 'javascript', 'lua', 'rust' }, disable = true })
			use({
				'Pocco81/DAPInstall.nvim',
				requires = 'mfussenegger/nvim-dap',
				ft = { 'javascript', 'lua', 'rust' },
				config = function()
					local dap_install = require('dap-install')

					dap_install.setup()
					dap_install.config('ccppr_lldb_dbg', {})
				end,
				disable = true,
			})
			use({
				'rcarriga/nvim-dap-ui',
				requires = 'mfussenegger/nvim-dap',
				ft = { 'javascript', 'lua', 'rust' },
				config = function()
					require('dapui').setup()
				end,
				disable = true,
			})
			use({
				'jbyuki/one-small-step-for-vimkind',
				requires = 'mfussenegger/nvim-dap',
				ft = { 'javascript', 'lua', 'rust' },
				disable = true,
			})

			-- Optional
			use({ 'wbthomason/packer.nvim', opt = true })
			use({ 'tweekmonster/startuptime.vim', opt = true })
		end,
		config = { display = { open_fn = require('packer.util').float } },
	})
end

function M.setup()
	bootstrap()
	init_packer()
end

return M

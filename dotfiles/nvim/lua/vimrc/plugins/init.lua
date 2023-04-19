local keymap = require('vimrc.utils.keymapping')
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
					vim.notify = require('notify')
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
				'williamboman/nvim-lsp-installer',
				requires = { 'neovim/nvim-lspconfig' },
			})
			use({
				'folke/trouble.nvim',
				requires = 'kyazdani42/nvim-web-devicons',
				config = function()
					require('vimrc.plugins.trouble')
				end,
			})
			use('folke/lua-dev.nvim')
			use({
				'simrat39/rust-tools.nvim',
				requires = {
					'neovim/nvim-lspconfig',
					'nvim-lua/popup.nvim',
					'nvim-lua/plenary.nvim',
					'nvim-telescope/telescope.nvim',
					'mfussenegger/nvim-dap',
				},
				ft = { 'rust' },
				config = function()
					require('rust-tools').setup({
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
						winbar = {
							enabled = false,
							name_formatter = function(term)
								return term.name
							end,
						},
					})

					local toggleterm_keymap = vim.api.nvim_create_augroup('toggleterm_keymap', { clear = true })
					vim.api.nvim_create_autocmd({ 'TermOpen' }, {
						group = toggleterm_keymap,
						pattern = { 'term://*' },
						callback = function()
							local opts = { buffer = 0 }
							keymap.tnoremap('<Esc>', [[<C-\><C-n>]], opts)
							keymap.tnoremap('<C-]>', [[<C-\><C-n>]], opts)
						end,
						desc = 'Set Toggleterm keymappings',
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
				setup = function()
					require('vimrc.plugins.ranger')
				end,
				cmd = '<leader>rr',
			})
			use('folke/which-key.nvim')
			use({
				'5c077m4n/surround-nvim-mirror',
				config = function()
					require('surround').setup({
						prefix = 'S',
						mappings_style = 'sandwich',
						pairs = {
							nestable = { { '(', ')' }, { '[', ']' }, { '{', '}' }, { '<', '>' } },
							linear = { { [[']], [[']] }, { [["]], [["]] }, { [[`]], [[`]] } },
						},
						brackets = { '(', '{', '[', '<' },
					})
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

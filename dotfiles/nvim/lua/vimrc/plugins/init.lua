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
							default = { 'class', 'function', 'method', 'for', 'while', 'if', 'switch', 'case' },
							rust = { 'impl', 'mod', 'struct', 'fn' },
							typescript = { 'const', 'let' },
						},
					})
				end,
				disable = true,
			})
			use({
				'nathom/filetype.nvim',
				config = function()
					require('filetype').setup({
						overrides = {
							extensions = {
								tsx = 'typescriptreact',
								jsx = 'javascriptreact',
								toml = 'toml',
							},
							literal = {
								['.prettierrc'] = 'json',
								['.babelrc'] = 'json',
								['.swcrc'] = 'json',
							},
							function_extensions = {
								conf = function()
									local filepath = vim.fn.expand('%')
									if string.find(filepath, '/kitty/') ~= nil then
										vim.bo.filetype = 'kitty'
									else
										vim.bo.filetype = 'conf'
									end
								end,
							},
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
					feline.setup()
				end,
			})
			use({
				'SmiteshP/nvim-navic',
				requires = { 'neovim/nvim-lspconfig', 'feline-nvim/feline.nvim' },
				config = function()
					local navic = require('nvim-navic')
					local feline = require('feline')

					navic.setup({ safe_output = true })

					local winbar_components = {
						active = {
							{
								{
									provider = { name = 'file_info', opts = { type = 'unique' } },
									short_provider = { name = 'file_info', opts = { type = 'unique-short' } },
								},
								{
									provider = ' | ',
									short_provider = '|',
									enabled = navic.is_available,
								},
								{
									provider = function()
										return navic.get_location({ depth_limit = 5 })
									end,
									short_provider = function()
										return navic.get_location({ depth_limit = 2 })
									end,
									enabled = navic.is_available,
								},
							},
						},
						inactive = {
							{
								{ provider = { name = 'file_info', opts = { type = 'short-path' } } },
							},
						},
					}
					feline.winbar.setup({
						disable = {
							filetypes = { '^neo-tree$', '^NvimTree$', '^packer$' },
							buftypes = { '^terminal$', '^nofile$' },
						},
						components = winbar_components,
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
			use('fladson/vim-kitty')
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
				run = function()
					vim.cmd.TSUpdate()
				end,
				config = function()
					require('vimrc.plugins.nvim-treesitter')
				end,
			})
			-- LSP
			use({
				'neovim/nvim-lspconfig',
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
				'jose-elias-alvarez/null-ls.nvim',
				requires = 'nvim-lua/plenary.nvim',
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
				tag = '*',
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
						hide_numbers = true,
						insert_mappings = true,
						terminal_mappings = true,
						shade_terminals = true,
					})
				end,
			})
			-- Code workflow
			use({
				'phaazon/hop.nvim',
				config = function()
					local hop = require('hop')
					local directions = require('hop.hint').HintDirection

					local keymap = require('vimrc.utils.keymapping')

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
				'windwp/nvim-ts-autotag',
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
			})
			use({
				'terrortylor/nvim-comment',
				config = function()
					require('nvim_comment').setup({
						marker_padding = true,
						comment_empty = false,
						create_mappings = true,
						line_mapping = '<leader>/',
						operator_mapping = '<leader>/',
					})
				end,
			})
			use({
				'monaqa/dial.nvim',
				requires = { 'nvim-lua/plenary.nvim' },
				config = function()
					require('vimrc.plugins.dial')
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

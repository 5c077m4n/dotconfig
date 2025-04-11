local M = {}

--- @return boolean
local function bootstrap()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({
			'git',
			'clone',
			'https://github.com/wbthomason/packer.nvim',
			install_path,
		})
		return true
	else
		return false
	end
end

function M.setup()
	local bootstrap_needed = bootstrap()

	require('packer').startup({
		function(use)
			-- General
			use('wbthomason/packer.nvim')
			use('nvim-lua/plenary.nvim')
			use({
				'aserowy/tmux.nvim',
				config = function()
					require('tmux').setup({
						resize = { enable_default_keybindings = false },
					})
				end,
				cond = function()
					return vim.env.TMUX ~= nil
				end,
			})
			use({
				'rcarriga/nvim-notify',
				config = function()
					local notify = require('notify')

					notify.setup({ stages = 'slide', render = 'compact', fps = 60 })
					vim.notify = notify
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
						events = { update_on_nvim_resize = true },
					})
				end,
			})
			-- Theme
			use({
				'projekt0n/github-nvim-theme',
				branch = '0.0.x',
				config = function()
					require('github-theme').setup({
						theme_style = 'dark_default',
						sidebars = { 'lazygit', 'terminal', 'packer' },
						dark_sidebar = false,
					})
					vim.cmd.colorscheme('github_dark_default')
				end,
				use({
					'nvim-lualine/lualine.nvim',
					after = 'github-nvim-theme',
					requires = {
						'SmiteshP/nvim-navic',
						{ 'nvim-tree/nvim-web-devicons', opt = true },
					},
					config = function()
						vim.cmd.packadd('nvim-web-devicons')
						require('vimrc.plugins.lualine')
					end,
				}),
			})
			use({
				'norcalli/nvim-colorizer.lua',
				events = { 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' },
				config = function()
					require('colorizer').setup()
				end,
			})
			use({
				'folke/todo-comments.nvim',
				events = { 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' },
				config = function()
					require('todo-comments').setup()
				end,
			})
			use({
				'onsails/lspkind-nvim',
				config = function()
					require('lspkind').init({ mode = 'text' }) -- Icons in autocomplete popup
				end,
			})
			use({ 'fladson/vim-kitty', ft = { 'kitty' } })
			use({ 'tmux-plugins/vim-tmux', ft = { 'tmux' } })
			-- File tree
			use({
				'nvim-neo-tree/neo-tree.nvim',
				branch = 'v2.x',
				requires = {
					'nvim-lua/plenary.nvim',
					{ 'nvim-tree/nvim-web-devicons', opt = true },
					'MunifTanjim/nui.nvim',
				},
				config = function()
					vim.cmd.packadd('nvim-web-devicons')
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
				'williamboman/mason.nvim',
				run = function()
					vim.cmd.MasonUpdate()
				end,
				config = function()
					require('mason').setup({
						ui = { border = 'single' },
					})
				end,
			})
			use({
				'williamboman/mason-lspconfig.nvim',
				config = function()
					require('mason-lspconfig').setup({
						ensure_installed = require('vimrc.plugins.lspconfig').SERVER_LIST,
						automatic_installation = true,
					})
				end,
				requires = 'neovim/nvim-lspconfig',
				after = 'mason.nvim',
			})
			use({
				'neovim/nvim-lspconfig',
				config = function()
					require('vimrc.plugins.lspconfig').setup()
				end,
				after = { 'mason.nvim', 'mason-lspconfig.nvim' },
			})
			use({
				'folke/trouble.nvim',
				requires = {
					{ 'nvim-tree/nvim-web-devicons', opt = true },
				},
				config = function()
					vim.cmd.packadd('nvim-web-devicons')

					require('trouble').setup({
						fold_open = 'v',
						fold_closed = '>',
						indent_lines = true,
						signs = { error = 'E', warning = 'W', hint = 'H', information = 'I' },
					})

					local keymap = require('vimrc.utils.keymapping')

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
					{
						'L3MON4D3/LuaSnip',
						tag = 'v1.*',
						run = 'make install_jsregexp',
						requires = { 'saadparwaiz1/cmp_luasnip' },
					},
					'hrsh7th/cmp-calc',
					'f3fora/cmp-spell',
					'onsails/lspkind-nvim',
				},
				config = function()
					require('vimrc.plugins.cmp')
				end,
			})
			-- Code workflow
			use({
				'phaazon/hop.nvim',
				event = { 'FocusGained', 'BufEnter' },
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
				event = { 'CursorHold', 'CursorHoldI' },
				requires = 'rbgrouleff/bclose.vim',
				config = function()
					local keymap = require('vimrc.utils.keymapping')

					keymap.nnoremap('<leader>rr', vim.cmd.Ranger, { desc = 'Open ranger file browser' })
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
				event = 'InsertEnter',
				tag = '*',
				config = function()
					require('nvim-surround').setup({})
				end,
			})
			use({
				'windwp/nvim-autopairs',
				event = 'InsertEnter',
				config = function()
					require('nvim-autopairs').setup({ check_ts = true })

					local cmp_autopairs = require('nvim-autopairs.completion.cmp')
					local cmp = require('cmp')

					cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
				end,
			})
			use({
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
			})
			use({
				'terrortylor/nvim-comment',
				event = { 'VimEnter', 'WinEnter', 'BufWinEnter' },
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
			-- Git
			use({
				'tpope/vim-fugitive',
				event = { 'VimEnter', 'WinEnter', 'BufWinEnter' },
				config = function()
					require('vimrc.plugins.git-fugitive')
				end,
			})
			use({
				'sindrets/diffview.nvim',
				requires = {
					'nvim-lua/plenary.nvim',
					{ 'nvim-tree/nvim-web-devicons', opt = true },
				},
				config = function()
					vim.cmd.packadd('nvim-web-devicons')
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
			use({
				'nvim-telescope/telescope-fzf-native.nvim',
				after = 'telescope.nvim',
				requires = 'nvim-telescope/telescope.nvim',
				run = 'make',
				config = function()
					require('telescope').load_extension('fzf')
				end,
			})
			-- Session
			use({
				'folke/persistence.nvim',
				event = { 'BufReadPre', 'FocusGained', 'BufEnter' },
				module = 'persistence',
				config = function()
					local persistence = require('persistence')
					local keymap = require('vimrc.utils.keymapping')

					persistence.setup({
						dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/'),
						---@diagnostic disable-next-line: undefined-field
						options = vim.opt.sessionoptions:get(),
						pre_save = function()
							require('neo-tree').close()
						end,
					})
					keymap.nnoremap('<leader>sl', persistence.load, { desc = 'Load relevant session' })
					keymap.nnoremap('<leader>ss', persistence.stop, { desc = 'Do not save session on vim exit' })
				end,
			})
			-- Debugging
			use({
				'nvim-telescope/telescope-dap.nvim',
				requires = 'nvim-telescope/telescope.nvim',
				disable = true,
			})
			use({
				'mfussenegger/nvim-dap',
				ft = { 'javascript', 'lua', 'rust' },
				disable = true,
			})
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

			-- Sync packer if needed (must be after all config has been set)
			if bootstrap_needed then
				require('packer').sync()
			end
		end,
		config = { display = { open_fn = require('packer.util').float } },
	})
end

return M

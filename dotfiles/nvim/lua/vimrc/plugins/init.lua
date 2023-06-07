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
			use(require('vimrc.plugins.tmux'))
			use(require('vimrc.plugins.notify'))
			use(require('vimrc.plugins.image'))
			-- Theme
			use(require('vimrc.plugins.theme'))
			use(require('vimrc.plugins.lualine'))
			use(require('vimrc.plugins.colorizer'))
			use(require('vimrc.plugins.todo-comments'))
			use(require('vimrc.plugins.lspkind'))
			use(require('vimrc.plugins.kitty'))
			use(require('vimrc.plugins.tmux-syntax'))
			-- File tree
			use(require('vimrc.plugins.neotree'))
			-- Treesitter
			use(require('vimrc.plugins.nvim-treesitter'))
			-- LSP
			use('folke/neodev.nvim')
			use(require('vimrc.plugins.mason'))
			use(require('vimrc.plugins.mason-lspconfig'))
			use(require('vimrc.plugins.lspconfig'))
			use(require('vimrc.plugins.typescript'))
			use(require('vimrc.plugins.trouble'))
			use(require('vimrc.plugins.go'))
			use(require('vimrc.plugins.null-ls'))
			-- Code snippets
			use(require('vimrc.plugins.cmp'))
			-- Code workflow
			use(require('vimrc.plugins.hop'))
			use(require('vimrc.plugins.ranger'))
			use(require('vimrc.plugins.which-key'))
			use(require('vimrc.plugins.surround'))
			use(require('vimrc.plugins.autopairs'))
			use(require('vimrc.plugins.ts-autotag'))
			use(require('vimrc.plugins.comment'))
			-- Git
			use(require('vimrc.plugins.fugitive'))
			use(require('vimrc.plugins.gitsigns'))
			-- Telescope
			use(require('vimrc.plugins.telescope'))
			use(require('vimrc.plugins.telescope-fzf'))

			-- Sync packer if needed (must be after all config has been set)
			if bootstrap_needed then
				require('packer').sync()
			end
		end,
		config = { display = { open_fn = require('packer.util').float } },
	})
end

return M

local lualine = require('lualine')
local navic = require('nvim-navic')

lualine.setup({
	sections = {
		lualine_c = {
			{
				'filename',
				symbols = { readonly = '🔒', modified = '💾' },
				file_status = true,
				newfile_status = true,
				path = 1,
				cond = function()
					return vim.bo.filetype ~= 'TelescopePrompt'
				end,
			},
		},
		lualine_x = {
			{
				'fileformat',
				icons_enabled = true,
				symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' },
			},
		},
	},
	winbar = {
		lualine_c = {
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return vim.bo.filetype ~= 'neo-tree' and navic.is_available()
				end,
				fmt = function(location)
					return location or ' '
				end,
			},
		},
		lualine_x = {
			{
				function()
					return (vim.bo.modified and ' 💾' or ' ')
				end,
				cond = function()
					return vim.bo.filetype ~= 'neo-tree' and navic.is_available()
				end,
			},
		},
	},
	inactive_winbar = {
		lualine_c = {
			{
				'filename',
				file_status = true,
				newfile_status = true,
				path = 1,
				cond = function()
					return vim.bo.filetype ~= 'neo-tree'
				end,
			},
		},
	},
	tabline = {
		lualine_b = {
			{
				'tabs',
				mode = 2,
				fmt = function(tab_name)
					return tab_name .. (vim.bo.modified == 1 and ' 💾' or '')
				end,
			},
		},
	},
})

--# selene: allow(mixed_table)

local lualine = require("lualine")
local navic = require("nvim-navic")
local lsp_progress = require("lsp-progress")

---@description Fish shell style path (`~/a/.b/c/filename.lua`)
---@param path string
---@return string
local function fish_style_path(path)
	local sep ---@type "\\" | "/"
	if vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1 then
		sep = "\\"
	else
		sep = "/"
	end
	local segments = vim.split(path, sep)

	local fish_path = ""
	for index, segment in pairs(segments) do
		if index ~= 1 then
			fish_path = fish_path .. sep
		end

		if index == #segments then
			fish_path = fish_path .. segment
		elseif segment:sub(1, 1) == "." then
			fish_path = fish_path .. segment:sub(1, 2)
		else
			fish_path = fish_path .. segment:sub(1, 1)
		end
	end
	return fish_path
end

lualine.setup({
	sections = {
		lualine_c = {
			{
				"filename",
				symbols = { readonly = "🔒", modified = "💾" },
				file_status = true,
				newfile_status = true,
				path = 1,
				cond = function()
					return vim.bo.filetype ~= "TelescopePrompt"
				end,
				fmt = function(filepath)
					return fish_style_path(filepath)
				end,
			},
		},
		lualine_x = {
			function()
				return lsp_progress.progress({})
			end,
		},
	},
	winbar = {
		lualine_c = {
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return vim.bo.filetype ~= "neo-tree" and navic.is_available()
				end,
				fmt = function(location)
					return location or " "
				end,
			},
		},
		lualine_x = {
			{
				function()
					return (vim.bo.modified and " 💾" or " ")
				end,
				cond = function()
					return vim.bo.filetype ~= "neo-tree" and navic.is_available()
				end,
			},
		},
	},
	inactive_winbar = {
		lualine_c = {
			{
				"filename",
				file_status = true,
				newfile_status = true,
				path = 1,
				cond = function()
					return vim.bo.filetype ~= "neo-tree" and vim.bo.filetype ~= "TelescopePrompt"
				end,
			},
		},
	},
	tabline = {
		lualine_b = {
			{
				"tabs",
				mode = 2,
				fmt = function(tab_name)
					return tab_name .. (vim.bo.modified == 1 and " 💾" or "")
				end,
			},
		},
	},
})

vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("update_lualine_on_lsp_progress", { clear = true }),
	pattern = "LspProgressStatusUpdated",
	callback = lualine.refresh,
})

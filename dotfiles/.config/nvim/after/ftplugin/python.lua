---@return boolean
local function should_use_tabs()
	local config_files = { "pyproject.toml", "ruff.toml", ".ruff.toml" }

	for _, config in ipairs(config_files) do
		local file = vim.fn.getcwd() .. "/" .. config

		if vim.fn.filereadable(file) == 1 then
			local yq_cmd = string.format(
				[[yq -r '.tool.ruff.format.indent-style // .format.indent-style // ""' %s 2>/dev/null]],
				vim.fn.shellescape(file)
			)
			local result = vim.fn.trim(vim.fn.system(yq_cmd))
			if result ~= "" then return result == "tab" end
		end
	end
	return false
end

vim.opt_local.expandtab = should_use_tabs()
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

vim.opt_local.foldmethod = "indent"

vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")

vim.cmd.inoreabbrev("<buffer> // #")
vim.cmd.inoreabbrev("<buffer> none None")

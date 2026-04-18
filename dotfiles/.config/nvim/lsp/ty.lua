---@type vim.lsp.Config
return {
	cmd = function()
		local binary_name = "ty"
		local venv_path = vim.fn.getcwd() .. "/.venv/bin/" .. binary_name

		if vim.fn.executable(venv_path) == 1 then return { venv_path } end
		return { binary_name }
	end,
	root_markers = { "pyproject.toml" },
	on_init = function() vim.lsp.enable("pyright", false) end,
}

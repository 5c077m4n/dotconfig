---@type vim.lsp.Config
return {
	settings = {
		gopls = {
			analyses = { undparams = true },
			staticcheck = true,
		},
	},
}

---@type vim.lsp.Config
return {
	settings = {
		["nil"] = {
			nix = {
				flake = { autoArchive = true },
			},
		},
	},
}

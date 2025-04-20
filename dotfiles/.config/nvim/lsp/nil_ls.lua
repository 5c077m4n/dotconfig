---@type vim.lsp.ClientConfig
return {
	settings = {
		["nil"] = {
			nix = {
				flake = { autoArchive = true },
			},
		},
	},
}

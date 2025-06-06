return {
	root_markers = { "Cargo.toml", "Cargo.lock" },
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = { group = "module" },
				prefix = "self",
			},
			cargo = {
				buildScripts = { enable = true },
			},
			procMacro = { enable = true },
		},
	},
}

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
			checkOnSave = {
				allFeatures = true,
				command = "clippy",
				extraArgs = {
					"--",
					"--no-deps",
					"-Dclippy::correctness",
					"-Dclippy::complexity",
					"-Wclippy::perf",
					"-Wclippy::pedantic",
				},
			},
			procMacro = { enable = true },
		},
	},
}

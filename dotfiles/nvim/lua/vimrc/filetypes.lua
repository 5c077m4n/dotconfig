vim.filetype.add({
	extension = {
		tsx = "typescriptreact",
		jsx = "javascriptreact",
		toml = "toml",
	},
	filename = {
		[".prettierrc"] = "json",
		[".babelrc"] = "json",
		[".swcrc"] = "json",
		[".sqlfluff"] = "toml",
		["tmux.conf"] = "tmux",
		[".env"] = "env",
		[".env.local"] = "env",
	},
	pattern = {
		[".*/kitty/.*%.conf$"] = "kitty",
		[".*/git/config"] = "gitconfig",
	},
})

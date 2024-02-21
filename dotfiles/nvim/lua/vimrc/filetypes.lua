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
		["tmux.conf"] = "tmux",
	},
	pattern = {
		[".*/kitty/.*%.conf$"] = "kitty",
		[".*/git/config"] = "gitconfig",
	},
})

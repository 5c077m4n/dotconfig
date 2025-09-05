vim.filetype.add({
	extension = {
		tsx = "typescriptreact",
		jsx = "javascriptreact",
		toml = "toml",
		["html.tmpl"] = "gohtmltmpl",
		tmpl = "gotexttmpl",
		templ = "templ",
	},
	filename = {
		[".prettierrc"] = "json",
		[".babelrc"] = "json",
		[".swcrc"] = "json",
		[".sqlfluff"] = "toml",
		["tmux.conf"] = "tmux",
		[".env"] = "env",
	},
	pattern = {
		[".env.*$"] = "env",
		[".*/kitty/.*%.conf$"] = "kitty",
		[".*/git/config"] = "gitconfig",
	},
})

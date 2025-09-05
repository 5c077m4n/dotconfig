return {
	cmd = { "tailwindcss-language-server" },
	filetypes = {
		"astro",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"templ",
	},
	settings = {
		tailwindCSS = {
			includeLanguages = { templ = "html" },
		},
	},
	root_markers = { "tailwind.config.js", "tailwind.config.ts" },
}

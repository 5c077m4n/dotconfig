---@type vim.lsp.ClientConfig
return {
	cmd = { "tailwindcss-language-server" },
	filetypes = { "javascriptreact", "typescriptreact", "html" },
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.ts",
	},
}

---@type vim.lsp.Config
return {
	filetypes = { "tf", "terraform" },
	root_markers = { ".terraform", "main.tf", "providers.tf" },
	cmd = { "terraform-ls", "serve" },
}

vim.g.markdown_fenced_languages = { "ts=typescript" }

---@type vim.lsp.ClientConfig
return {
	root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
}

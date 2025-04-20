local schemastore = require("schemastore")

---@type vim.lsp.ClientConfig
return {
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
}

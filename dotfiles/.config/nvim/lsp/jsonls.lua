local schemastore = require("schemastore")

---@type vim.lsp.Config
return {
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
}

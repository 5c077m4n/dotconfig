local inlay_hints = {
	includeInlayEnumMemberValueHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayFunctionParameterTypeHints = true,
	includeInlayParameterNameHints = "all", ---@type 'none' | 'literals' | 'all'
	includeInlayParameterNameHintsWhenArgumentMatchesName = true,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayVariableTypeHints = false,
}

---@type vim.lsp.Config
return {
	settings = {
		javascript = { inlayHints = inlay_hints },
		typescript = { inlayHints = inlay_hints },
		javascriptreact = { inlayHints = inlay_hints },
		typescriptreact = { inlayHints = inlay_hints },
	},
}

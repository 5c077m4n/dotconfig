local SERVER_LIST = {
	"ts_ls",
	"cssls",
	"html",
	"tailwindcss",
	"biome",
	"bashls",
	"lua_ls",
	"ruff",
	"pyright",
	"rust_analyzer",
	"gopls",
	"golangci_lint_ls",
	"nil_ls",
	"jsonls",
	"yamlls",
	"marksman",
	"sqlls",
	"taplo",
	"dockerls",
	"zls",
	"gleam",
	"svelte",
}

local function setup()
	vim.lsp.config("*", {
		capabilities = {
			textDocument = {
				completion = {
					completionItem = { snippetSupport = true },
				},
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		},
	})
	vim.lsp.enable(SERVER_LIST)
end

return {
	setup = vim.schedule_wrap(setup),
	SERVER_LIST = SERVER_LIST,
}

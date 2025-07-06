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
	"fish_lsp",
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

	--- HACK: running `vim.lsp.enable` "regularly" on startup doesn't work for some reason...
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		group = vim.api.nvim_create_augroup("enable_lsp_on_vim_enter_once", { clear = true }),
		callback = function()
			vim.defer_fn(function() vim.lsp.enable(SERVER_LIST) end, 50)
		end,
	})
end

return {
	setup = setup,
	SERVER_LIST = SERVER_LIST,
}

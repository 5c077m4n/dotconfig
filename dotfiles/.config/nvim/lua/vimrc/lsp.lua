local SERVER_LIST = {
	"ts_ls",
	"denols",
	"cssls",
	"html",
	"tailwindcss",
	"biome",
	"bashls",
	"lua_ls",
	"vue_ls",
	"ruff",
	"ty",
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
	"jsonnet_ls",
	"templ",
	"astro",
	"swift",
	"terraform_ls",
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
			vim.defer_fn(function()
				local server_list = vim.iter(SERVER_LIST)
					:filter(function(server) return server ~= "rust_analyzer" end)
					:totable()
				vim.lsp.enable(server_list)
			end, 50)
		end,
	})
end

return {
	setup = setup,
	SERVER_LIST = SERVER_LIST,
}

local utils = require("vimrc.utils")

local keymap = utils.keymapping

return {
	"stevearc/conform.nvim",
	event = { "VeryLazy" },
	init = function() vim.o.formatexpr = "v:lua.require('conform').formatexpr()" end,
	config = function()
		local js_linters = { "biome", "biome-check", "biome-organize-imports" }

		require("conform").setup({
			formatters = {
				stylua = {
					prepend_args = { "--verify" },
				},
				sqlfluff = {
					args = { "fix", "--dialect=postgres", "-" },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt" },
				typescript = js_linters,
				javascript = js_linters,
				typescriptreact = js_linters,
				javascriptreact = js_linters,
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				go = { "golangci-lint", "golines" },
				toml = { "taplo" },
				yaml = { "prettierd" },
				json = { "biome" },
				html = { "prettierd" },
				css = { "stylelint" },
				markdown = { "deno_fmt" },
				sh = { "shellharden", "shfmt" },
				bash = { "shellharden", "shfmt" },
				zsh = { "shellharden", "shfmt" },
				fish = { "fish_indent" },
				nix = { "nixfmt" },
				gleam = { "gleam" },
				sql = { "sqlfluff" },
			},
		})

		vim.api.nvim_create_autocmd({ "LspAttach" }, {
			group = vim.api.nvim_create_augroup("setup_conform_formatters", { clear = true }),
			callback = function(args)
				keymap.nvnoremap(
					"<leader>l",
					function() require("conform").format({ bufnr = args.buf }) end,
					{
						buffer = args.buf,
						desc = "[conform.nvim] Format selected buffer/range",
					}
				)
			end,
		})
	end,
}

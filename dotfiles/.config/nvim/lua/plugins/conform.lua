---@module 'lazy'
---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "VeryLazy" },
	init = function() vim.o.formatexpr = "v:lua.require('conform').formatexpr()" end,
	config = function()
		local conform = require("conform")

		local js_linters = { "biome", "biome-check", "biome-organize-imports" }
		conform.setup({
			formatters = {
				stylua = {
					prepend_args = { "--verify" },
				},
				sqlfluff = {
					args = { "fix", "--dialect=postgres", "-" },
				},
				rustfmt = {
					prepend_args = { "+nightly" },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt" },
				typescript = js_linters,
				javascript = js_linters,
				typescriptreact = js_linters,
				javascriptreact = js_linters,
				astro = { "prettier" },
				svelte = { "prettier" },
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				go = { "golangci-lint", "golines" },
				gotexttmpl = { "golangci-lint" },
				gohtmltmpl = { "prettier", "golangci-lint" },
				templ = { "templ" },
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
				jsonnet = { "jsonnetfmt" },
				libsonnet = { "jsonnetfmt" },
				swift = { "swift" },
			},
		})

		vim.api.nvim_create_autocmd({ "LspAttach" }, {
			group = vim.api.nvim_create_augroup("setup_conform_formatters", { clear = true }),
			callback = function(args)
				local keymap = require("vimrc.utils").keymapping

				keymap.nvnoremap("<leader>l", function() conform.format({ bufnr = args.buf }) end, {
					buffer = args.buf,
					desc = "[conform.nvim] Format selected buffer/range",
				})
			end,
		})
	end,
}

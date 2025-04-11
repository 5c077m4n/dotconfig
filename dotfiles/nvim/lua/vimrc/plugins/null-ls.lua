local null_ls = require('null-ls')

local eslint_config = {
	prefer_local = 'node_modules/.bin',
	condition = function(utils)
		return utils.root_has_file({ 'package.json' })
	end,
	extra_args = { '--cache' },
}

null_ls.setup({
	diagnostics_format = '[#{c}] #{m} (#{s})',
	sources = {
		-- Snippet support
		null_ls.builtins.completion.luasnip,
		-- Lua
		null_ls.builtins.formatting.stylua.with({
			condition = function(utils)
				return utils.root_has_file({ 'stylua.toml', '.stylua.toml' })
			end,
		}),
		null_ls.builtins.diagnostics.luacheck.with({
			condition = function(utils)
				return utils.root_has_file({ '.luacheckrc' })
			end,
		}),
		--null_ls.builtins.diagnostics.selene,
		-- Python
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.mypy,
		-- Typescript
		null_ls.builtins.code_actions.eslint.with(eslint_config),
		null_ls.builtins.diagnostics.eslint.with(eslint_config),
		null_ls.builtins.formatting.eslint.with(eslint_config),
		null_ls.builtins.formatting.prettier.with({ prefer_local = 'node_modules/.bin' }),
		-- Deno
		null_ls.builtins.formatting.deno_fmt.with({
			condition = function(utils)
				return utils.root_has_file({ 'deno.json', 'deno.jsonc', 'deno.lock' })
			end,
		}),
		-- CSS
		null_ls.builtins.formatting.stylelint,
		-- Shell
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.formatting.shellharden,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.beautysh,
		-- SQL
		null_ls.builtins.formatting.sqlformat,
		-- Rust
		null_ls.builtins.formatting.rustfmt.with({ args = { '+nightly' } }),
		-- Zig
		null_ls.builtins.formatting.zigfmt.with({
			condition = function(utils)
				return utils.root_has_file({ 'build.zig' })
			end,
		}),
		-- Go
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.diagnostics.gospel,
		null_ls.builtins.diagnostics.staticcheck,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.golines,
		-- ZSH
		null_ls.builtins.diagnostics.zsh,
		-- Terraform
		null_ls.builtins.formatting.terraform_fmt,
		-- YAML
		null_ls.builtins.diagnostics.yamllint,
		-- TOML
		null_ls.builtins.formatting.taplo,
		-- Misc
		null_ls.builtins.completion.spell,
		--null_ls.builtins.diagnostics.editorconfig_checker,
		--null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.refactoring,
	},
	update_in_insert = false,
	debounce = 200,
})

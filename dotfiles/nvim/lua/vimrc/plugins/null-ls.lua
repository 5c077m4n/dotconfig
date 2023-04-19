local null_ls = require('null-ls')

local eslint_config = {
	prefer_local = 'node_modules/.bin',
	condition = function(utils)
		return utils.root_has_file({ 'package.json' })
	end,
}

null_ls.setup({
	diagnostics_format = '[#{c}] #{m} (#{s})',
	sources = {
		-- lua
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
		-- python
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.mypy,
		-- typescript
		null_ls.builtins.code_actions.eslint.with(eslint_config),
		null_ls.builtins.diagnostics.eslint.with(eslint_config),
		null_ls.builtins.formatting.eslint.with(eslint_config),
		null_ls.builtins.formatting.prettier.with({ prefer_local = 'node_modules/.bin' }),
		-- deno
		null_ls.builtins.formatting.deno_fmt.with({
			condition = function(utils)
				return utils.root_has_file({ 'deno.json', 'deno.jsonc', 'deno.lock' })
			end,
		}),
		-- css
		null_ls.builtins.formatting.stylelint,
		-- shell
		null_ls.builtins.formatting.shellharden,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.code_actions.shellcheck,
		-- sql
		null_ls.builtins.formatting.sqlformat,
		-- rust
		null_ls.builtins.formatting.rustfmt.with({ args = { '+nightly' } }),
		-- zig
		null_ls.builtins.formatting.zigfmt.with({
			condition = function(utils)
				return utils.root_has_file({ 'build.zig' })
			end,
		}),
		-- zsh
		null_ls.builtins.diagnostics.zsh,
		-- terraform
		null_ls.builtins.formatting.terraform_fmt,
		-- yaml
		null_ls.builtins.diagnostics.yamllint,
		-- toml
		null_ls.builtins.formatting.taplo,
		-- misc
		null_ls.builtins.completion.spell,
		--null_ls.builtins.diagnostics.editorconfig_checker,
		--null_ls.builtins.code_actions.gitsigns,
	},
	update_in_insert = false,
	debounce = 200,
})

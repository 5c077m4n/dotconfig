local null_ls = require('null-ls')

local ts_config = { prefer_local = 'node_modules/.bin' }

null_ls.setup({
	diagnostics_format = '[#{c}] #{m} (#{s})',
	sources = {
		-- lua
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.luacheck,
		--null_ls.builtins.diagnostics.selene,
		-- python
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.mypy,
		-- typescript
		null_ls.builtins.code_actions.eslint.with(ts_config),
		null_ls.builtins.diagnostics.eslint.with(ts_config),
		null_ls.builtins.formatting.eslint.with(ts_config),
		null_ls.builtins.formatting.prettier.with(ts_config),
		-- deno
		--null_ls.builtins.formatting.deno_fmt,
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
		-- zsh
		null_ls.builtins.diagnostics.zsh,
		-- terraform
		null_ls.builtins.formatting.terraform_fmt,
		-- markdown
		null_ls.builtins.diagnostics.write_good.with(ts_config),
		-- yaml
		null_ls.builtins.diagnostics.yamllint,
		-- toml
		null_ls.builtins.formatting.taplo,
		-- misc
		null_ls.builtins.completion.spell,
		--null_ls.builtins.diagnostics.editorconfig_checker,
		--null_ls.builtins.code_actions.gitsigns,
	},
	should_attach = function(bufnr)
		return not vim.api.nvim_buf_get_name(bufnr):match('/node_modules/')
	end,
	update_in_insert = false,
	debounce = 200,
})

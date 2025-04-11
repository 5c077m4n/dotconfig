local null_ls = require("null-ls")

local null_ls_builtins = require("vimrc.plugins.null-ls.builtins")

local sources = {
	-- Snippet support
	null_ls.builtins.completion.luasnip,
	-- Lua
	null_ls.builtins.formatting.stylua.with({
		condition = function(utils)
			return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
		end,
	}),
	null_ls.builtins.diagnostics.selene.with({
		condition = function(utils)
			return utils.root_has_file({ "selene.toml" })
		end,
	}),
	-- Python
	null_ls.builtins.formatting.isort.with({ prefer_local = ".venv/bin" }),
	null_ls.builtins.formatting.black.with({ prefer_local = ".venv/bin" }),
	null_ls.builtins.diagnostics.pylint.with({ prefer_local = ".venv/bin" }),
	null_ls.builtins.diagnostics.mypy.with({ prefer_local = ".venv/bin" }),
	-- Typescript
	null_ls.builtins.formatting.prettierd.with({ extra_filetypes = { "toml" } }),
	-- CSS
	null_ls.builtins.formatting.stylelint,
	-- Rust
	null_ls_builtins.formatting.rustfmt,
	-- Shell
	null_ls.builtins.formatting.shellharden,
	null_ls.builtins.formatting.shfmt,
	-- SQL
	null_ls.builtins.formatting.sqlfluff,
	null_ls.builtins.diagnostics.sqlfluff,
	-- Go
	null_ls.builtins.formatting.gofumpt,
	null_ls.builtins.formatting.goimports,
	null_ls.builtins.formatting.goimports_reviser,
	null_ls.builtins.formatting.golines.with({
		extra_args = {
			"--max-len=100",
			"--base-formatter=gofumpt",
		},
	}),
	null_ls.builtins.code_actions.impl,
	-- ZSH
	null_ls.builtins.diagnostics.zsh,
	-- Fish
	null_ls.builtins.formatting.fish_indent,
	null_ls.builtins.diagnostics.fish,
	-- Nix
	null_ls.builtins.formatting.nixfmt,
	null_ls.builtins.diagnostics.deadnix,
	null_ls.builtins.code_actions.statix,
	-- Terraform
	null_ls.builtins.formatting.terraform_fmt,
	-- YAML
	null_ls.builtins.diagnostics.yamllint,
	-- Dockerfile
	null_ls.builtins.diagnostics.hadolint,
	-- Misc
	null_ls.builtins.completion.spell,
	--null_ls.builtins.diagnostics.editorconfig_checker,
	--null_ls.builtins.code_actions.gitsigns,
	null_ls.builtins.code_actions.refactoring,
}

null_ls.setup({
	diagnostics_format = "[#{c}] #{m} (#{s})",
	sources = sources,
	update_in_insert = false,
	debounce = 400,
})

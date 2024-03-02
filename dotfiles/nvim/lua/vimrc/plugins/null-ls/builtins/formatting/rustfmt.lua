local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")

return helpers.make_builtin({
	name = "rustfmt",
	meta = {
		url = "https://github.com/rust-lang/rustfmt",
		description = "A tool for formatting rust code according to style guidelines.",
		notes = {
			"`--edition` defaults to `2015`. To set a different edition, use `extra_args`.",
			"See [the wiki](https://github.com/nvimtools/none-ls.nvim/wiki/Source-specific-Configuration#rustfmt) for other workarounds.",
		},
	},
	method = methods.internal.FORMATTING,
	filetypes = { "rust" },
	generator_opts = {
		command = "rustfmt",
		args = { "--emit=stdout" },
		to_stdin = true,
	},
	factory = helpers.formatter_factory,
})

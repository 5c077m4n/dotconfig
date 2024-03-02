local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")

return helpers.make_builtin({
	name = "eslint_d",
	meta = {
		url = "https://github.com/mantoni/eslint_d.js/",
		description = "Like ESLint, but faster.",
		notes = {
			"Once spawned, the server will continue to run in the background. This is normal and not related to null-ls. You can stop it by running `eslint_d stop` from the command line.",
		},
	},
	method = methods.internal.FORMATTING,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	generator_opts = {
		command = "eslint_d",
		args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
		to_stdin = true,
	},
	factory = helpers.formatter_factory,
})

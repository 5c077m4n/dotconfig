local methods = require("null-ls.methods")
local h = require("null-ls.helpers")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
	name = "ruff",
	meta = {
		url = "https://github.com/astral-sh/ruff/",
		description = "An extremely fast Python formatter, written in Rust.",
	},
	method = FORMATTING,
	filetypes = { "python" },
	generator_opts = {
		command = "ruff",
		args = { "format", "-n", "--stdin-filename", "$FILENAME", "-" },
		to_stdin = true,
	},
	factory = h.formatter_factory,
})

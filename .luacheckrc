---@diagnostic disable: lowercase-global
cache = true -- Rerun tests only if their modification time changed.

std = "luajit"
codes = true

read_globals = { "vim" }

--- Glorious list of warnings: https://luacheck.readthedocs.io/en/stable/warnings.html
ignore = {
	"211", --- Unused variable, _arg_name is easier to understand than _
	"212", --- Unused argument, In the case of callback function
	"122", --- Indirectly setting a readonly global
}

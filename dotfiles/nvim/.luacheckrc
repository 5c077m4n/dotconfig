-- Rerun tests only if their modification time changed.
cache = true

std = "luajit"
codes = true

read_globals = { "vim", "vimp" }
files["lua/vimrc/globals.lua"] = {
	globals = { "table" },
}
files["lua/vimrc/utils/modules.lua"] = {
	globals = { "packer_plugins" },
}

-- Glorious list of warnings: https://luacheck.readthedocs.io/en/stable/warnings.html
ignore = {
	"211", -- Unused variable, _arg_name is easier to understand than _, so this option is set to off.
	"212", -- Unused argument, In the case of callback function, _arg_name is easier to understand than _, so this option is set to off.
	"122", -- Indirectly setting a readonly global
}

exclude_files = { "plugin/packer_compiled.lua" }

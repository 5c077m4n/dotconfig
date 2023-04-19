-- Rerun tests only if their modification time changed.
cache = true

std = 'luajit'
codes = true

read_globals = { 'vim', 'packer_plugins' }

--- Glorious list of warnings: https://luacheck.readthedocs.io/en/stable/warnings.html
ignore = {
	--- Unused variable, _arg_name is easier to understand than _, so this option is set to off.
	'211',
	--- Unused argument, In the case of callback function, _arg_name is easier to understand than _, so this option is set to off.
	'212',
	--- Indirectly setting a readonly global
	'122',
}

exclude_files = { 'plugin/packer_compiled.lua' }

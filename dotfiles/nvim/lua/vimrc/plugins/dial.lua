local dial_map = require('dial.map')
local dial_augend = require('dial.augend')
local dial_config = require('dial.config')

local keymap = require('vimrc.utils.keymapping')

local default_group = {
	dial_augend.integer.alias.decimal,
	dial_augend.integer.alias.decimal_int,
	dial_augend.integer.alias.hex,
	dial_augend.integer.alias.binary,
	dial_augend.date.alias['%H:%M'],
	dial_augend.date.alias['%Y/%m/%d'],
	dial_augend.semver.alias.semver,
	dial_augend.constant.alias.bool,
	dial_augend.constant.alias.alpha,
	dial_augend.constant.alias.Alpha,
	dial_augend.constant.new({
		elements = { 'and', 'or' },
		word = true,
		cyclic = true,
	}),
	dial_augend.constant.new({
		elements = { '!=', '==' },
		word = false,
		cyclic = true,
	}),
	dial_augend.constant.new({
		elements = { '&&', '||' },
		word = false,
		cyclic = true,
	}),
}
dial_config.augends:register_group({
	default = default_group,
	typescript = {
		dial_augend.constant.new({
			elements = { 'const', 'let' },
			word = true,
			cyclic = true,
		}),
		unpack(default_group),
	},
})

keymap.nnoremap('<C-a>', dial_map.inc_normal(), { desc = 'Toggle value up' })
keymap.nnoremap('<C-x>', dial_map.dec_normal(), { desc = 'Toggle value down' })
keymap.vnoremap('<C-a>', dial_map.inc_visual(), { desc = 'Toggle value up' })
keymap.vnoremap('<C-x>', dial_map.dec_visual(), { desc = 'Toggle value down' })
keymap.vnoremap('g<C-a>', dial_map.inc_gvisual(), { desc = 'Toggle value (globally) up' })
keymap.vnoremap('g<C-x>', dial_map.dec_gvisual(), { desc = 'Toggle value (globally) down' })

local typescript_dial = vim.api.nvim_create_augroup('typescript_dial', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType' }, {
	group = typescript_dial,
	pattern = {
		'javascript',
		'javascriptreact',
		'javascript.jsx',
		'typescript',
		'typescriptreact',
		'typescript.tsx',
	},
	callback = function(opts)
		keymap.nnoremap('<C-a>', dial_map.inc_normal('typescript'), { buffer = opts.buf, desc = 'Toggle value up' })
		keymap.nnoremap('<C-x>', dial_map.dec_normal('typescript'), { buffer = opts.buf, desc = 'Toggle value down' })
		keymap.vnoremap('<C-a>', dial_map.inc_visual('typescript'), { buffer = opts.buf, desc = 'Toggle value up' })
		keymap.vnoremap('<C-x>', dial_map.dec_visual('typescript'), { buffer = opts.buf, desc = 'Toggle value down' })
		keymap.vnoremap(
			'g<C-a>',
			dial_map.inc_gvisual('typescript'),
			{ buffer = opts.buf, desc = 'Toggle value (globally) up' }
		)
		keymap.vnoremap(
			'g<C-x>',
			dial_map.dec_gvisual('typescript'),
			{ buffer = opts.buf, desc = 'Toggle value (globally) down' }
		)
	end,
	desc = 'Toggle values in JavaScript/TypeScript files',
})

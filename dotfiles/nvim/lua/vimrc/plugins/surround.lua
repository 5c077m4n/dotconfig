require('surround').setup({
	prefix = 'S',
	mappings_style = 'sandwich',
	pairs = {
		nestable = { { '(', ')' }, { '[', ']' }, { '{', '}' }, { '<', '>' } },
		linear = { { [[']], [[']] }, { [["]], [["]] } },
	},
	brackets = { '(', '{', '[', '<' },
})

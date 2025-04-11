---@param mode string|table
local function create_keymap_fn(mode)
	mode = mode or "n"

	---@param buttons string
	---@param command string|function
	---@param options? table
	return function(buttons, command, options)
		local opts = vim.tbl_extend("force", { remap = true, silent = true }, options or {})
		vim.keymap.set(mode, buttons, command, opts)
	end
end

return {
	nnoremap = create_keymap_fn("n"),
	vnoremap = create_keymap_fn("v"),
}

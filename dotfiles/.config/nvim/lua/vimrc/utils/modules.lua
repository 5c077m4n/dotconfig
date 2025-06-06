local M = {}

local log_level = vim.log.levels

local function unload_background_buffers()
	local buffer_list = vim.fn.getbufinfo()

	for _, buffer in ipairs(buffer_list) do
		if buffer.hidden == 1 and buffer.loaded == 1 and buffer.changed == 0 then
			vim.cmd.bunload(buffer.bufnr)
		end
	end
end

function M.reload_vimrc()
	vim.cmd.source(vim.env.MYVIMRC)
	vim.loader.reset()

	unload_background_buffers()

	vim.notify("Reload successful", vim.log.levels.INFO, { title = "VIMRC" })
end

return M

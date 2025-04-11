local reload_vimrc = require("vimrc.utils.modules").reload_vimrc

local uv, split, trim, system = vim.loop, vim.split, vim.trim, vim.fn.system
local USR1_SIGNAL = "sigusr1"

local function handle_usr1()
	local signal_handler = uv.new_signal()

	if signal_handler ~= nil then
		uv.signal_start_oneshot(signal_handler, USR1_SIGNAL, function(signal_usr1)
			vim.notify('Received a "' .. string.upper(signal_usr1) .. '" signal, reloading...')
			vim.schedule(reload_vimrc)
		end)
	end
end

local function send_usr1_to_all_nvim()
	local nvim_pids = split(trim(system({ "pgrep", "nvim" })), "\n")

	for _, pid_str in ipairs(nvim_pids) do
		local pid = tonumber(pid_str)

		if type(pid) == "number" then
			vim.notify("Sending a reload signal to NVIM instance (PID " .. pid .. ")")
			uv.kill(pid, USR1_SIGNAL)
		end
	end
end

return {
	handle_usr1 = handle_usr1,
	send_usr1_to_all_nvim = send_usr1_to_all_nvim,
}

--- Check if a file exists using Lua (no subprocess).
---@param path string
---@return boolean
local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

---@param cmd string|string[]
---@return string
local function normalize_command(cmd)
	if type(cmd) == "table" then return table.concat(cmd, " ; ") end
	return cmd
end

---@class tmux
local TMUX = {}
TMUX.__index = TMUX

--- Create a new tmux instance with its own command queue.
---@return tmux
function TMUX:new() return setmetatable({ cmd_queue = {} }, self) end

function TMUX:cmd(...)
	local args = { ... }
	for i, v in ipairs(args) do
		args[i] = "'" .. tostring(v):gsub("'", "'\\''") .. "'"
	end
	table.insert(self.cmd_queue, "tmux " .. table.concat(args, " "))
end

---@param option string
---@param value string|integer
function TMUX:set_append(option, value) self:cmd("set-option", "-ag", option, tostring(value)) end

---@param option string
---@param value string|integer|(string|integer)[]
function TMUX:set(option, value)
	if type(value) == "table" then
		self:cmd("set-option", "-g", option, tostring(value[1]))
		for i = 2, #value do
			self:set_append(option, value[i])
		end
	else
		self:cmd("set-option", "-g", option, tostring(value))
	end
end

---@param option string
---@param value string|integer
function TMUX:set_window(option, value) self:cmd("set-window-option", "-g", option, tostring(value)) end

---@param key string
function TMUX:unbind(key) self:cmd("unbind-key", key) end

---@param key string
---@param command string|string[]
function TMUX:bind(key, command) self:cmd("bind-key", key, normalize_command(command)) end

---@param key string
---@param command string|string[]
function TMUX:bind_n(key, command) self:cmd("bind-key", "-n", key, normalize_command(command)) end

---@param key string
---@param command string|string[]
function TMUX:bind_r(key, command) self:cmd("bind-key", "-r", key, normalize_command(command)) end

---@param key string
---@param command string|string[]
function TMUX:bind_rn(key, command) self:cmd("bind-key", "-rn", key, normalize_command(command)) end

---@param table string
---@param key string
---@param command string|string[]
function TMUX:bind_table(table, key, command)
	self:cmd("bind-key", "-T", table, key, normalize_command(command))
end

---@param table string
---@param key string
function TMUX:unbind_table(table, key) self:cmd("unbind-key", "-T", table, key) end

---@param condition string
---@param then_cmd string|string[]
---@param else_cmd? string|string[]
function TMUX:if_shell(condition, then_cmd, else_cmd)
	local args = { "if-shell", condition, normalize_command(then_cmd) }
	if else_cmd then args[#args + 1] = normalize_command(else_cmd) end
	self:cmd(unpack(args))
end

---@param path string
function TMUX:run_plugin(path)
	if not file_exists(path) then
		self:display("Warning: plugin script not found: " .. path)
		return
	end
	self:cmd("run", path)
end

---@param msg string
function TMUX:display(msg) self:cmd("display-message", msg) end

--- Fetch a plugin from git, cache it, and apply optional config.
--- Clones if missing, but skips fetching on every start (that's slow).
---@param spec string|{ url: string, commit?: string, disable?: boolean, config?: fun(t: tmux, plugin_dir: string) }
function TMUX:plugin(spec)
	if type(spec) == "string" then spec = { url = spec } end
	if spec.disable then return end

	local cache_dir = (os.getenv("XDG_CACHE_HOME") or os.getenv("HOME") .. "/.cache")
		.. "/tmux-plugins"
	local owner, repo = spec.url:match("([^/]+)/([^/]+)%.git$")
	if not owner or not repo then
		owner, repo = spec.url:match("([^/]+)/([^/]+)$")
	end
	local plugin_name --[[@type string]] = owner .. "/" .. repo
	local plugin_dir --[[@type string]] = cache_dir .. "/" .. plugin_name

	if not file_exists(plugin_dir .. "/.git/HEAD") then
		local ok = os.execute(
			"mkdir -p " .. cache_dir .. " && git clone --depth 1 " .. spec.url .. " " .. plugin_dir
		)
		if not ok then
			self:display("Plugin could not be installed: " .. plugin_name)
			return
		end
		self:display("Plugin installed: " .. plugin_name)
	end

	if spec.commit then
		local current_commit --[[@type string?]] = nil
		local head_handle = io.popen("cd " .. plugin_dir .. " && git rev-parse HEAD 2>/dev/null")
		if head_handle then
			current_commit = tostring(head_handle:read("*l"))
			head_handle:close()
		end

		if current_commit ~= spec.commit then
			local ok = os.execute(
				"cd "
					.. plugin_dir
					.. " && git fetch --depth 1 origin "
					.. spec.commit
					.. " && git checkout "
					.. spec.commit
					.. " --quiet"
			)
			if not ok then
				self:display(
					"Warning: commit '"
						.. spec.commit
						.. "' could not be checked out for '"
						.. plugin_name
						.. "'"
				)
				return
			end
			self:display("Plugin updated: " .. plugin_name)
		end
	end

	local run_script --[[@type string?]] = nil
	local candidates --[[@type string[] ]] = {
		plugin_dir .. "/" .. plugin_name .. ".tmux",
		plugin_dir .. "/scripts/" .. plugin_name .. ".tmux",
		plugin_dir .. "/tmux/" .. plugin_name .. ".tmux",
	}
	for _, c in ipairs(candidates) do
		if file_exists(c) then
			run_script = c
			break
		end
	end

	if not run_script then
		local handle = io.popen("ls " .. plugin_dir .. "/*.tmux 2>/dev/null")
		if handle then
			run_script = tostring(handle:read("*l"))
			handle:close()
		end
	end

	if not run_script then
		self:display("Warning: no .tmux script found for plugin '" .. plugin_name .. "'")
		return
	end

	if type(spec.config) == "function" then spec.config(self) end
	self:run_plugin(run_script)
end

--- Source a tmux configuration file.
---@param file string Path to the config file to source.
function TMUX:source(file)
	if not file_exists(file) then
		self:display("Warning: source file not found: " .. file)
		return
	end
	self:cmd("source", file)
end

--- Is the current OS MacOS?
---@return boolean
function TMUX:is_darwin() return file_exists("/usr/bin/sw_vers") end

--- Execute all queued commands in a single shell invocation.
--- Call this once after all configuration is done.
function TMUX:flush()
	if #self.cmd_queue == 0 then return end
	os.execute(table.concat(self.cmd_queue, " ; "))
	self.cmd_queue = {}
end

return TMUX

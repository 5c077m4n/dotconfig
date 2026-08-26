#!/usr/bin/env luajit

local TERM_RESET = "\27[0m"
local TERM_DIM = "\27[2m"
local TERM_BOLD = "\27[1m"
local TERM_BLUE = "\27[38;5;110m"
local TERM_GREEN = "\27[38;5;114m"
local TERM_YELLOW = "\27[38;5;179m"
local TERM_RED = "\27[38;5;203m"
local TERM_MAGENTA = "\27[38;5;176m"
local TERM_GRAY = "\27[38;5;244m"
local TERM_SEP = " " .. TERM_GRAY .. "│" .. TERM_RESET .. " "

local ICON_MODEL = "󰚩"
local ICON_FOLDER = "󰉋"
local ICON_BRANCH = "󰊢"
local ICON_WORKTREE = "󰙅"
local ICON_CONTEXT = "󰧑"
local ICON_COST = "󰆛"
local ICON_VIM_INSERT = "󰏫"
local ICON_VIM_NORMAL = "󰌌"
local ICON_AUTORUN = "󰄙"
local ICON_MAX = "󰓅"

local BYTE_SPACE = 32
local BYTE_TAB = 9
local BYTE_LINE_FEED = 10
local BYTE_CARRIAGE_RETURN = 13
local BYTE_DOUBLE_QUOTE = 34
local BYTE_BACKSLASH = 92
local BYTE_DIGIT_ZERO = 48
local BYTE_DIGIT_NINE = 57

local UTF8_SINGLE_BYTE_MAX = 0x80
local UTF8_TWO_BYTE_MAX = 0x800
local UTF8_TWO_BYTE_LEAD_BASE = 0xC0
local UTF8_THREE_BYTE_LEAD_BASE = 0xE0
local UTF8_CONTINUATION_BASE = 0x80
local UTF8_SIX_BIT_MASK = 0x40
local UTF8_TWELVE_BIT_DIVISOR = 0x1000
local UNICODE_ESCAPE_HEX_LENGTH = 4

---@alias JsonValue string|number|boolean|table|nil

---@param json_text string
---@return JsonValue
local function decode_json(json_text)
	local index = 1
	local length = #json_text

	---@return string
	local function peek() return json_text:sub(index, index) end

	---@return nil
	local function skip()
		while index <= length do
			local byte = json_text:byte(index)
			if
				byte ~= BYTE_SPACE
				and byte ~= BYTE_TAB
				and byte ~= BYTE_LINE_FEED
				and byte ~= BYTE_CARRIAGE_RETURN
			then
				break
			end
			index = index + 1
		end
	end

	---@param codepoint integer
	---@return string
	local function utf8_encode(codepoint)
		if codepoint < UTF8_SINGLE_BYTE_MAX then
			return string.char(codepoint)
		elseif codepoint < UTF8_TWO_BYTE_MAX then
			return string.char(
				UTF8_TWO_BYTE_LEAD_BASE + math.floor(codepoint / UTF8_SIX_BIT_MASK),
				UTF8_CONTINUATION_BASE + codepoint % UTF8_SIX_BIT_MASK
			)
		end
		return string.char(
			UTF8_THREE_BYTE_LEAD_BASE + math.floor(codepoint / UTF8_TWELVE_BIT_DIVISOR),
			UTF8_CONTINUATION_BASE + math.floor(codepoint / UTF8_SIX_BIT_MASK) % UTF8_SIX_BIT_MASK,
			UTF8_CONTINUATION_BASE + codepoint % UTF8_SIX_BIT_MASK
		)
	end

	---@return string
	local function parse_string()
		index = index + 1
		local parts = {}
		while index <= length do
			local byte = json_text:byte(index)
			if byte == BYTE_DOUBLE_QUOTE then
				index = index + 1
				return table.concat(parts)
			elseif byte == BYTE_BACKSLASH then
				index = index + 1
				local escape = json_text:sub(index, index)
				if escape == "u" then
					local codepoint = tonumber(
						json_text:sub(index + 1, index + UNICODE_ESCAPE_HEX_LENGTH),
						16
					) or 0
					index = index + UNICODE_ESCAPE_HEX_LENGTH
					parts[#parts + 1] = utf8_encode(codepoint)
				else
					local escapes = {
						['"'] = '"',
						["\\"] = "\\",
						["/"] = "/",
						b = "\b",
						f = "\f",
						n = "\n",
						r = "\r",
						t = "\t",
					}
					parts[#parts + 1] = escapes[escape] or escape
				end
				index = index + 1
			else
				local run_end = index
				while run_end <= length do
					local run_byte = json_text:byte(run_end)
					if run_byte == BYTE_DOUBLE_QUOTE or run_byte == BYTE_BACKSLASH then break end
					run_end = run_end + 1
				end
				parts[#parts + 1] = json_text:sub(index, run_end - 1)
				index = run_end
			end
		end
		error("unterminated string")
	end

	---@return number
	local function parse_number()
		local start = index

		if peek() == "-" then index = index + 1 end
		while true do
			local byte = json_text:byte(index)
			if not byte or byte < BYTE_DIGIT_ZERO or byte > BYTE_DIGIT_NINE then break end
			index = index + 1
		end

		if peek() == "." then
			index = index + 1
			while true do
				local byte = json_text:byte(index)
				if not byte or byte < BYTE_DIGIT_ZERO or byte > BYTE_DIGIT_NINE then break end
				index = index + 1
			end
		end
		local char = peek()
		if char == "e" or char == "E" then
			index = index + 1
			char = peek()
			if char == "+" or char == "-" then index = index + 1 end
			while true do
				local byte = json_text:byte(index)
				if not byte or byte < BYTE_DIGIT_ZERO or byte > BYTE_DIGIT_NINE then break end
				index = index + 1
			end
		end
		return tonumber(json_text:sub(start, index - 1)) or 0
	end

	---@generic T
	---@param literal string
	---@param value T
	---@return T
	local function parse_literal(literal, value)
		if json_text:sub(index, index + #literal - 1) ~= literal then
			error("expected " .. literal)
		end
		index = index + #literal
		return value
	end

	---@type fun(): JsonValue
	local parse_value

	---@return JsonValue[]
	local function parse_array()
		index = index + 1
		local array = {}
		skip()
		if peek() == "]" then
			index = index + 1
			return array
		end
		while true do
			array[#array + 1] = parse_value()
			skip()
			local char = peek()
			if char == "]" then
				index = index + 1
				return array
			end
			if char ~= "," then error("expected , or ]") end
			index = index + 1
			skip()
		end
	end

	---@return table<string, JsonValue>
	local function parse_object()
		index = index + 1
		local object = {}
		skip()
		if peek() == "}" then
			index = index + 1
			return object
		end
		while true do
			skip()
			if peek() ~= '"' then error("expected string key") end
			local key = parse_string()
			skip()
			if peek() ~= ":" then error("expected :") end
			index = index + 1
			object[key] = parse_value()
			skip()
			local char = peek()
			if char == "}" then
				index = index + 1
				return object
			end
			if char ~= "," then error("expected , or }") end
			index = index + 1
		end
	end

	---@return JsonValue
	parse_value = function()
		skip()
		local char = peek()
		if char == '"' then
			return parse_string()
		elseif char == "{" then
			return parse_object()
		elseif char == "[" then
			return parse_array()
		elseif char == "t" then
			return parse_literal("true", true)
		elseif char == "f" then
			return parse_literal("false", false)
		elseif char == "n" then
			return parse_literal("null", nil)
		elseif char == "-" or (char >= "0" and char <= "9") then
			return parse_number()
		end
		error("unexpected char: " .. tostring(char))
	end

	return parse_value()
end

---@param text string
---@return string
local function shell_quote(text) return "'" .. text:gsub("'", "'\\''") .. "'" end

---@param command string
---@return string
local function capture(command)
	local handle = io.popen(command)
	if not handle then return "" end
	local output = handle:read("*a") or ""
	handle:close()

	return (output:gsub("%s+$", ""))
end

---@param directory string
---@param args string
---@return string
local function git(directory, args)
	return capture("git -C " .. shell_quote(directory) .. " " .. args .. " 2>/dev/null")
end

--- One call: `git status --porcelain -b` is a repo check, branch name, and dirty flag.
---@param directory string
---@return string, boolean
local function git_info(directory)
	local output = git(directory, "status --porcelain -b")
	if output == "" then return "", false end

	local header, rest = output:match("^## ([^\n]*)\n?(.*)$")
	if not header or header == "HEAD (no branch)" then return "", false end

	local branch = header:match("^(.-)%.%.%.") or header
	branch = branch:match("^No commits yet on (.+)$") or branch

	return branch, rest ~= ""
end

---@param data table
---@return string
local function model_segment(data)
	local model = type(data.model) == "table" and data.model or {}
	return TERM_BLUE
		.. TERM_BOLD
		.. ICON_MODEL
		.. " "
		.. (model.display_name or "unknown")
		.. TERM_RESET
end

---@param data table
---@return string
local function folder_segment(data)
	local workspace = type(data.workspace) == "table" and data.workspace or {}
	local directory = workspace.current_dir or data.cwd or "."

	local folder = directory:match("([^/]+)$")
	if not folder or folder == "" then folder = "/" end
	return TERM_SEP .. TERM_DIM .. ICON_FOLDER .. " " .. folder .. TERM_RESET
end

---@param data table
---@return string
local function git_segment(data)
	local workspace = type(data.workspace) == "table" and data.workspace or {}
	local directory = workspace.current_dir or data.cwd or "."

	local branch, dirty = git_info(directory)
	if branch == "" then return "" end
	local segment = TERM_SEP .. TERM_MAGENTA .. ICON_BRANCH .. " " .. branch .. TERM_RESET
	if dirty then segment = segment .. TERM_YELLOW .. "*" .. TERM_RESET end

	return segment
end

---@param data table
---@return string
local function worktree_segment(data)
	local worktree = type(data.worktree) == "table" and data.worktree or {}
	local name = worktree.name
	if not name or name == "" then return "" end

	return TERM_SEP .. TERM_DIM .. ICON_WORKTREE .. " " .. name .. TERM_RESET
end

---@param data table
---@return string
local function context_segment(data)
	local context_window = type(data.context_window) == "table" and data.context_window or {}
	local percent = math.floor(tonumber(context_window.used_percentage) or 0)
	local filled = math.min(10, math.max(0, math.floor(percent / 10)))

	local color = TERM_GREEN
	if percent >= 85 then
		color = TERM_RED
	elseif percent >= 60 then
		color = TERM_YELLOW
	end

	return TERM_SEP
		.. color
		.. ICON_CONTEXT
		.. " ["
		.. string.rep("#", filled)
		.. string.rep("-", 10 - filled)
		.. "] "
		.. percent
		.. "%"
		.. TERM_RESET
end

---@param data table
---@return string
local function cost_segment(data)
	local cost_info = type(data.cost) == "table" and data.cost or {}
	local dollars = cost_info.total_cost_usd
	if dollars == nil then return "" end

	return TERM_SEP .. TERM_DIM .. ICON_COST .. " $" .. string.format("%.2f", dollars) .. TERM_RESET
end

---@param data table
---@return string
local function vim_segment(data)
	local vim_info = type(data.vim) == "table" and data.vim or {}
	local mode = vim_info.mode
	if not mode or mode == "" then return "" end

	local icon = ICON_VIM_NORMAL
	if mode == "INSERT" then icon = ICON_VIM_INSERT end

	return TERM_SEP .. TERM_DIM .. icon .. " " .. TERM_RESET
end

---@param data table
---@return string
local function autorun_segment(data)
	if data.autorun ~= true then return "" end
	return TERM_SEP .. TERM_YELLOW .. ICON_AUTORUN .. " auto" .. TERM_RESET
end

---@param data table
---@return string
local function max_segment(data)
	local model = type(data.model) == "table" and data.model or {}
	if model.max_mode ~= true then return "" end

	return TERM_SEP .. TERM_YELLOW .. ICON_MAX .. " max" .. TERM_RESET
end

---@return table
local function read_payload()
	local input = io.read("*a") or ""
	local decoded, data = pcall(decode_json, input)
	if not decoded or type(data) ~= "table" then os.exit(1) end

	return data
end

local data = read_payload()
io.write(
	model_segment(data)
		.. folder_segment(data)
		.. git_segment(data)
		.. worktree_segment(data)
		.. context_segment(data)
		.. cost_segment(data)
		.. vim_segment(data)
		.. autorun_segment(data)
		.. max_segment(data)
		.. "\n"
)

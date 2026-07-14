package.path = package.path .. ";./dotfiles/.config/tmux/?.lua"
local TMUX --[[@type tmux]] = require("tmux")

local tmux = TMUX:new()

tmux:unbind("C-b")
tmux:set("prefix", "C-a")
tmux:bind("C-a", "send-prefix")

tmux:bind("x", "kill-pane")
tmux:set("detach-on-destroy", "off")

tmux:set("base-index", 1)
tmux:set_window("pane-base-index", 1)
tmux:set("renumber-windows", "on")

tmux:set("status-left-length", 100)
tmux:set("status-right-length", 100)
tmux:set("status-left", "")
tmux:set("status-style", "bg=default")
tmux:set("focus-events", "on")
tmux:set_window("aggressive-resize", "on")

tmux:set_window("mode-keys", "vi")

tmux:set_window("visual-bell", "both")
tmux:set_window("bell-action", "other")

tmux:set("escape-time", 10)
tmux:set("clock-mode-style", 24)
tmux:set("default-command", os.getenv("SHELL") or "/bin/bash")

tmux:unbind("%")
tmux:bind("\\", "split-window -h -l 40% -c '#{pane_current_path}'")
tmux:unbind('"')
tmux:bind("-", "split-window -v -l 40% -c '#{pane_current_path}'")

tmux:bind_r("j", "resize-pane -D 10")
tmux:bind_r("k", "resize-pane -U 10")
tmux:bind_r("l", "resize-pane -R 10")
tmux:bind_r("h", "resize-pane -L 10")

tmux:unbind("Enter")
tmux:bind("Enter", "resize-pane -Z")

tmux:bind_n("M-k", { "send-keys -R", "send-keys C-l", "clear-history" })

tmux:unbind("c")
tmux:unbind("n")
tmux:bind("n", "new-window -c '#{pane_current_path}'")

tmux:unbind("w")
tmux:bind("w", "kill-window")

tmux:unbind("q")
tmux:bind("q", "kill-server")

tmux:unbind("C-a")
tmux:bind("C-a", "choose-tree -wZ")

tmux:unbind("Escape")
tmux:bind_rn("M-[", "previous-window")
tmux:bind_rn("M-]", "next-window")
tmux:bind_rn("M-{", { "swap-window -t -1", "select-window -t -1" })
tmux:bind_rn("M-}", { "swap-window -t +1", "select-window -t +1" })

tmux:bind_table("copy-mode-vi", "Escape", "send-keys -X cancel")
tmux:bind_table("copy-mode-vi", "C-[", "send-keys -X cancel")
tmux:bind_table("copy-mode-vi", "v", "send-keys -X begin-selection")
tmux:bind_table("copy-mode-vi", "V", { "send-keys -X begin-selection", "send-keys -X end-of-line" })
tmux:bind_table("copy-mode-vi", "C-v", "send-keys -X rectangle-toggle")
tmux:bind_table("copy-mode-vi", "y", "send-keys -X copy-selection")

tmux:unbind_table("copy-mode-vi", "MouseDragEnd1Pane")

tmux:plugin({
	url = "https://github.com/tmux-plugins/tmux-sensible",
	commit = "25cb91f42d020f675bb0a2ce3fbd3a5d96119efa",
})
tmux:plugin({
	url = "https://github.com/aserowy/tmux.nvim",
	commit = "2c1c3be0ef287073cef963f2aefa31a15c8b9cd8",
	config = function(t)
		t:set("@tmux-nvim-navigation", "true")
		t:set("@tmux-nvim-navigation-cycle", "true")
		t:set("@tmux-nvim-navigation-keybinding-left", "C-h")
		t:set("@tmux-nvim-navigation-keybinding-down", "C-j")
		t:set("@tmux-nvim-navigation-keybinding-up", "C-k")
		t:set("@tmux-nvim-navigation-keybinding-right", "C-l")
		t:set("@tmux-nvim-resize", "false")

		if tmux:is_darwin() then
			t:set(
				"@tmux-nvim-condition",
				"ps -o command -t '#{pane_tty}' | grep --extended-regexp --ignore-case --quiet 'n?vim'"
			)
		end
	end,
})
tmux:plugin({
	url = "https://github.com/catppuccin/tmux",
	commit = "d2d25bd3393fe43f19eb4fff6cdd2bdf5578e622",
	config = function(t)
		local flavor = "macchiato"
		local zoom_icon_query = "#{?window_zoomed_flag,[\238\174\129],}"

		t:set(
			"status-right",
			{ " #{E:@catppuccin_status_application} ", " #{E:@catppuccin_status_session} " }
		)
		t:set("@catppuccin_flavor", flavor)
		t:set("@catppuccin_status_background", "default")
		t:set("@catppuccin_window_status_style", "rounded")
		t:set("@catppuccin_window_text", " #W " .. zoom_icon_query)
		t:set("@catppuccin_window_default_text", " #W " .. zoom_icon_query)
		t:set("@catppuccin_window_current_text", " #W " .. zoom_icon_query)
	end,
})

--- MacOS clipboard integration
if tmux:is_darwin() then
	tmux:bind_table(
		"copy-mode-vi",
		"MouseDragEnd1Pane",
		"send-keys -X copy-pipe-and-cancel reattach-to-user-namespace pbcopy"
	)
end

tmux:unbind("r")
local tmux_conf_path = (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config")
	.. "/tmux/tmux.conf"
tmux:bind("r", {
	"source-file " .. tmux_conf_path,
	"display 'Refreshed config file @ " .. tmux_conf_path .. "'",
})

tmux:flush()

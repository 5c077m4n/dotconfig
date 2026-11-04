#!/usr/bin/env bash

set -euo pipefail

readonly ALL_STAGES=(install startup load-all health)

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
isolated_home="${NVIM_SANITY_HOME:-${RUNNER_TEMP:-${TMPDIR:-/tmp}}/nvim-sanity}"
nvim_timeout_seconds="${NVIM_TIMEOUT:-600}"

print_usage_and_exit() {
	echo "usage: $(basename "$0") [${ALL_STAGES[*]}]..." >&2
	exit 2
}

use_isolated_xdg_dirs() {
	export XDG_CONFIG_HOME="$isolated_home/config"
	export XDG_DATA_HOME="$isolated_home/data"
	export XDG_STATE_HOME="$isolated_home/state"
	export XDG_CACHE_HOME="$isolated_home/cache"
	mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"
}

copy_config_so_repo_lockfile_stays_untouched() {
	rm -rf "$XDG_CONFIG_HOME/nvim"
	cp -R "$repo_root/dotfiles/.config/nvim" "$XDG_CONFIG_HOME/nvim"
}

read -r -d '' exit_with_failure_on_reported_errors <<'LUA' || true
local error_lines = vim.iter(vim.split(vim.fn.execute("messages"), "\n"))
	:filter(function(line) return line:match("^E%d+:") or line:match("Error") end)
	:totable()
if vim.v.errmsg ~= "" then table.insert(error_lines, 1, "v:errmsg: " .. vim.v.errmsg) end
if #error_lines > 0 then
	io.stderr:write(table.concat(error_lines, "\n") .. "\n")
	vim.cmd.cquit(1)
end
LUA

read -r -d '' print_uninstalled_plugin_names <<'LUA' || true
local uninstalled_names = vim.iter(require("lazy").plugins())
	:filter(function(plugin) return not plugin._.installed end)
	:map(function(plugin) return plugin.name end)
	:totable()
io.stdout:write(table.concat(uninstalled_names, " "))
LUA

nvim_headless_with_timeout() {
	timeout "$nvim_timeout_seconds" nvim --headless "$@" </dev/null
}

run_nvim_and_fail_on_errors() {
	local output_log
	output_log="$(mktemp)"

	if ! nvim_headless_with_timeout "$@" -c "lua $exit_with_failure_on_reported_errors" -c "qa!" >"$output_log" 2>&1; then
		cat "$output_log"
		echo "::error::nvim exited with an error ($*)"
		return 1
	fi

	cat "$output_log"
	if grep -qE '^(E[0-9]+:|Error )|stack traceback' "$output_log"; then
		echo "::error::errors found in nvim output ($*)"
		return 1
	fi
}

stage_install() {
	echo "==> Installing plugins from lazy-lock.json"
	run_nvim_and_fail_on_errors -c "Lazy! restore"

	local uninstalled_plugins
	uninstalled_plugins="$(nvim_headless_with_timeout -c "lua $print_uninstalled_plugin_names" -c "qa!" 2>&1)"
	if [[ -n "$uninstalled_plugins" ]]; then
		echo "::error::plugins not installed: $uninstalled_plugins"
		return 1
	fi
}

stage_startup() {
	echo "==> Startup with plugins installed"
	run_nvim_and_fail_on_errors
}

stage_load_all() {
	echo "==> Loading every plugin (incl. lazy-loaded ones)"
	run_nvim_and_fail_on_errors -c "lua require('lazy').load({ plugins = vim.tbl_keys(require('lazy.core.config').plugins) })"
}

stage_health() {
	echo "==> :checkhealth lazy"
	local health_report="$isolated_home/health.txt"
	nvim_headless_with_timeout -c "checkhealth lazy" -c "w! $health_report" -c "qa!" >/dev/null 2>&1
	cat "$health_report"

	if grep -q "ERROR" "$health_report"; then
		echo "::error::checkhealth lazy reported errors"
		return 1
	fi
}

main() {
	local stages=("$@")
	[[ ${#stages[@]} -eq 0 ]] && stages=("${ALL_STAGES[@]}")

	for stage in "${stages[@]}"; do
		[[ " ${ALL_STAGES[*]} " == *" $stage "* ]] || print_usage_and_exit
	done

	use_isolated_xdg_dirs
	copy_config_so_repo_lockfile_stays_untouched

	for stage in "${stages[@]}"; do
		"stage_${stage//-/_}"
	done
}

main "$@"

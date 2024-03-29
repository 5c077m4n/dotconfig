plugins=(fzf rust)
[[ -n "${ITERM_SESSION_ID}" ]] && plugins+=(iterm2)

() {
	local plugins_custom=(
		hlissner/zsh-autopair
		zsh-users/zsh-autosuggestions
		zsh-users/zsh-completions
		zsh-users/zsh-syntax-highlighting
	)

	local plug_repo
	for plug_repo in $plugins_custom; do
		local plug_name="$(echo "$plug_repo" | sed 's|.*\/||')"
		local plug_dir="${ZSH_CUSTOM}/plugins/${plug_name}"

		if [[ ! -d "$plug_dir" ]]; then
			git clone "https://github.com/${plug_repo}" "$plug_dir"
		fi
		plugins+=($plug_name)

		if [[ $plug_name == 'zsh-completions' ]]; then
			fpath+=("${ZSH_CUSTOM}/plugins/${plug_name}/src")
		fi
	done
}

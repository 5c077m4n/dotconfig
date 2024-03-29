# TMUX - TPM
() {
	local tpm_path="${XDG_STATE_HOME}/tmux/plugins/tpm/"
	if [[ -x "$(command -v tmux)" && ! -d "$tpm_path" ]]; then
		git clone https://github.com/tmux-plugins/tpm "$tpm_path"
	fi
}

if [[ ! -f "${ZSH}/oh-my-zsh.sh" ]]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

() {
	local xdg_dir
	for xdg_dir in $(printenv | grep '^XDG_.*_HOME=' | sed 's/.*=//'); do
		[[ ! -d "$xdg_dir" ]] && mkdir -p "$xdg_dir"
	done
}

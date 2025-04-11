# TMUX - TPM
() {
	local tpm_path="${XDG_STATE_HOME}/tmux/plugins/tpm/"
	if [[ -x "$(command -v tmux)" && ! -d "$tpm_path" ]]; then
		git clone https://github.com/tmux-plugins/tpm "$tpm_path"
	fi
}

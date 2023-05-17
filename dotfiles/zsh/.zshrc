for zsh_config_file in "${ZDOTDIR}/config/"*; do
	source "$zsh_config_file"
done
unset zsh_config_file

eval "$(starship init zsh)"

# De-duplicate path environment variables
typeset -U path
typeset -U fpath
typeset -U cdpath

for zsh_config_file in ${ZDOTDIR}/conf.d/*.zsh; do
	source "$zsh_config_file"
done
unset zsh_config_file

# De-duplicate path environment variables
typeset -U path
typeset -U fpath
typeset -U cdpath

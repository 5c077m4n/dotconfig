zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 2

HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy.mm.dd"

for zsh_config_file in "${ZDOTDIR}/config/"*; do
	source "$zsh_config_file"
done
unset zsh_config_file

source "${ZSH}/oh-my-zsh.sh"
eval "$(starship init zsh)"

# De-duplicate path environment variables
typeset -U path
typeset -U fpath
typeset -U cdpath

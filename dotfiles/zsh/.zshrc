if [[ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ]]; then
	zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)
fi
source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

plug "zap-zsh/completions"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
plug "hlissner/zsh-autopair"

for zsh_config_file in "${ZDOTDIR}/config/"*; do
	plug "$zsh_config_file"
done
unset zsh_config_file

plug "${HOME}/.fzf.zsh"
plug "${HOME}/.cargo/env"
plug "${HOME}/.iterm2_shell_integration.zsh"

# Init starship
eval "$(starship init zsh)"

# De-duplicate path environment variables
typeset -U path
typeset -U fpath
typeset -U cdpath

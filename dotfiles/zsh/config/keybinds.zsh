# Kitty search
[[ -x "$(command -v kitty)" ]] && compdef _rg hg

# `zsh-history-substring-search` keymaps
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Reduce `vi-cmd-mode` sensitivity
vi-cmd-mode() {
	local is_esc=1 REPLY
	while (( KEYS_QUEUED_COUNT || PENDING )); do
		is_esc=0
		zle read-command
	done
	((is_esc)) && zle .$WIDGET
}
zle -N vi-cmd-mode
KEYTIMEOUT=10

bindkey '^[f' forward-word
bindkey '^[b' backward-word

autoload -z edit-command-line; zle -N edit-command-line
bindkey '^X^E' edit-command-line

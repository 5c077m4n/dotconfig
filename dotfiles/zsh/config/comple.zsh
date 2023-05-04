# Completions
## Kubectl
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion zsh)
## Kitty search
[[ -x "$(command -v kitty)" ]] && compdef _rg hg

# `zsh-history-substring-search` keymaps
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

[[ -f "${HOME}/.zcompdump" ]] && rm -f "${HOME}/.zcompdump"
compinit

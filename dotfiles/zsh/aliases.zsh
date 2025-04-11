#!/usr/bin/env zsh

# Python
alias python='python3'

# Neovim
alias v='nvim'
alias vim='nvim'
alias 'v.'='nvim .'

# exa -> ls
if (( $+commands[exa] )); then
	alias ls='exa' # just replace ls by exa and allow all other exa arguments
fi
alias l='ls -lbF' # list, size, type
alias ll='ls -la' # long, all
alias llm='ll --sort=modified' # list, long, sort by modification date
alias la='ls -lbhHigUmuSa' # all list
alias lx='ls -lbhHigUmuSa@' # all list and extended
alias tree='exa --tree' # tree view
alias lS='exa -1' # one column by just names

# Kubectl
alias kk='kubectl krew'
alias kns='kubens'
alias kc='kubectx'
alias kcc='kubectx --current'

# Git
gbdefault () {
	command git rev-parse --git-dir &> /dev/null || return 1

	local ref
	for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}; do
		if $(git show-ref --quiet --verify "$ref"); then
			echo "${ref:t}"
			return
		fi
	done
	echo "master"
}
alias gbcurrent='git branch --show-current'
alias gupa='git pull --rebase --autostash origin "$(gbcurrent)"'
alias ggpf='git push --force origin "$(gbcurrent)"'
alias gprom='git pull --rebase --autostash --stat origin "$(gbdefault)"'
alias grbim='git rebase --interactive --autostash --autosquash "$(gbdefault)"'

# Rust
alias c='cargo'
alias ct='cargo test'
alias ctw='cargo test --workspace'
ctwl () {
	RUST_LOG=debug cargo test --workspace "$@" -- --nocapture
}
alias cc='cargo clean'
alias cr='cargo run'
alias crl='RUST_LOG=debug cargo run'
alias cb='cargo build'
alias cu='cargo update'

# NPM
alias ni='npm install'
alias nci='npm clean-install'
alias nis='npm install --save'
alias nisd='npm install --save-dev'
alias nif='npm install --force'
alias nr='npm run'
alias nclean='npm cache clean --force'

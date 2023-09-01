#!/usr/bin/env zsh

# Python
alias python='python3'

# Neovim
alias v='nvim'
alias vim='nvim'

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
alias kns='kubens'
alias kc='kubectx'
alias kcc='kubectx --current'

# Git
alias gbcurrent='git branch --show-current'
alias gsync='git fetch --all --prune && git pull origin "$(gbcurrent)" --all --rebase --autostash'
alias gupa='git pull --rebase --autostash origin "$(gbcurrent)"'
alias ggpf='git push --force origin "$(gbcurrent)"'
alias gprom='git pull --rebase --autostash origin "$(git_main_branch)"'
alias grbim='git rebase --interactive --autostash --autosquash "$(git_main_branch)"'
## Worktree
gwta() {
	cd "$(git rev-parse --show-toplevel)"
	git worktree add "$1"
	cd "$1"
}
alias gwtr='git worktree remove'
alias gwtl='git worktree list'
alias gwtp='git worktree prune'

# Rust
alias c='cargo'
alias ct='cargo test'
alias ctw='cargo test --workspace'
ctwl() {
	RUST_LOG=debug cargo test --workspace "$@" -- --nocapture
}
alias cc='cargo clean'
alias cr='cargo run'
alias crl='RUST_LOG=debug cargo run'
alias cb='cargo build'
alias cu='cargo update'

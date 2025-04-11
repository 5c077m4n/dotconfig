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

update-hosts() {
	local current_hosts="$(cat /etc/hosts)"
	local anti_malware_hosts="$(curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts)"
	local fakenews_gambling_hosts="$(curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts)"

	echo "${current_hosts} \n${anti_malware_hosts} \n${fakenews_gambling_hosts}" | sed 's/^\s+\|\s+$//g' | sed '/^\s*#\|^$/d' | sort --unique | sudo tee /etc/hosts
}

# Kubectl
alias kns='kubens'
alias kc='kubectx'
alias kcc='kubectx --current'

# Git
alias gsync='git fetch --all --prune && git pull origin "$(git branch --show-current) --all --rebase --autostash'
alias gupa='git pull --rebase --autostash origin "$(git branch --show-current)"'
alias ggpf='git push --force origin "$(git branch --show-current)"'
alias gprom='git pull --rebase --autostash origin "$(git_main_branch)"'
alias grbim='git rebase --interactive origin/master'
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

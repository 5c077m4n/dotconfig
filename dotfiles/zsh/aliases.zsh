#!/usr/bin/env zsh

# `cd` into a temp dir
alias cdt='cd "$(mktemp -d)"'

# exa -> ls
if (( $+commands[exa] )); then
	alias ls='exa' # just replace ls by exa and allow all other exa arguments
	alias tree='exa --tree' # tree view
fi
alias l='ls -lbF' # list, size, type
alias ll='ls -la' # long, all
alias la='ls -lbhHigUmuSa' # all list
alias lx='ls -lbhHigUmuSa@' # all list and extended

# Package manager update
if (( $+commands[brew] )); then
	alias pkgup='brew update && brew upgrade && brew upgrade --cask'
elif (( $+commands[pacman] )); then
	alias pkgup='sudo pacman -Syu'
	alias pkgupy='sudo pacman -Syu --noconfirm'
	alias pkgclean='sudo pacman -Scc'
	alias pkgdblock='rm /var/lib/pacman/db.lock'
elif (( $+commands[apk] )); then
	alias pkgup='sudo apk update && sudo apk upgrade'
	alias pkgupy='sudo apk update && sudo apk upgrade --yes'
elif (( $+commands[apt] )); then
	alias pkgup='sudo apt update && sudo apt upgrade'
	alias pkgupy='sudo apt update && sudo apt upgrade --yes'
fi

# Neovim
alias v='nvim'
alias vim='nvim'
alias 'v.'='nvim .'

# Git
if (( $+commands[hub] )); then
	alias git='hub'
fi
alias gsh='git show --show-signature'
alias gst='git status'
<<<<<<< HEAD
=======
alias gstv='git status -vv'
>>>>>>> b366f57 (fixup! Add conditions on aliases)
alias gd='git diff'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'
alias gdsw='git diff --staged --word-diff'
alias gfa='git fetch --all --prune'
alias ga='git add'
alias 'ga.'='git add .'
alias gaa='git add --all'
alias gau='git add --update'
alias gap='git add --patch'
alias gc='git commit --verbose'
alias 'gc!'='git commit --verbose --amend'
alias gcmsg='git commit --verbose --message'
alias gcam='git commit --verbose --all --message'
alias 'gcan!'='git commit --verbose --amend --all --no-edit'
alias 'gcane!'='git commit --verbose --amend --all --no-edit --allow-empty'
alias gbcurrent='git branch --show-current'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout "$(gbdefault)"'
alias 'gco-'='git checkout -'
alias 'gco.'='git checkout .'
alias gupa='git pull --autostash --stat origin "$(git branch --show-current)"'
alias gprom='git pull --rebase --autostash --stat origin "$(gbdefault)"'
alias ggpf='git push --force-with-lease origin "$(gbcurrent)"'
alias grbi='git rebase --interactive --autostash --autosquash'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias grbq='git rebase --quit'
alias grbim='git rebase --interactive --autostash --autosquash "$(gbdefault)"'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias gclean='git clean -d --interactive'
alias gnewtag='git describe --tags "$(git rev-list --tags --max-count=1)"'

# Rust
if (( $+commands[cargo] )); then
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
fi

# NPM
if (( $+commands[npm] )); then
	alias ni='npm install'
	alias nci='npm clean-install'
	alias ncif='npm clean-install --force'
	alias nis='npm install --save'
	alias nisd='npm install --save-dev'
	alias nif='npm install --force'
	alias nr='npm run'
	alias nclean='npm cache clean --force'
fi

# Kubectl
if (( $+commands[kubectl] )); then
	alias k='kubectl'
	alias ke='kubectl edit'
	alias kk='kubectl krew'
	alias kg='kubectl get'
	alias kd='kubectl delete'
	alias kds='kubectl delete service'
	alias kdc='kubectl delete configmap'
	alias kdn='kubectl delete namespace'
	alias kc='kubectl create'
	alias kcn='kubectl create namespace'
	alias kgp='kubectl get pod'
	alias kgs='kubectl get service'
	alias kgc='kubectl get configmap'
	alias kgn='kubectl get namespace'
	alias kpf='kubectl port-forward'
fi
# Kubectl utils
if (( $+commands[kubens] )); then
	alias kns='kubens'
	alias knsc='kubens --current'
fi
if (( $+commands[kubectx] )); then
	alias kc='kubectx'
	alias kcc='kubectx --current'
fi
# Terraform
if (( $+commands[terraform] )); then
	alias t='terraform'
	alias ta='terraform apply'
	alias tp='terraform plan'
fi

# Python
alias python='python3'

# SSH
alias evssh='eval "$(ssh-agent -s)"'

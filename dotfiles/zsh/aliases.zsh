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
alias k='kubectl'
alias kk='kubectl krew'
alias kpf='kubectl port-forward'
# Kubectl utils
alias kns='kubens'
alias kc='kubectx'
alias kcc='kubectx --current'
# Terraform
alias t='terraform'
alias ta='terraform apply'
alias tp='terraform plan'

# Git
alias gsh='git show --show-signature'
alias gst='git status'
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
alias gcmsg='git commit --verbose --message'
alias gcam='git commit --verbose --all --message'
alias 'gcan!'='git commit --verbose --amend --all --no-edit'
alias 'gc!'='git commit --verbose --amend'
alias gbcurrent='git branch --show-current'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout "$(gbdefault)"'
alias 'gc-'='git checkout -'
alias gupa='git pull --rebase --autostash origin "$(gbcurrent)"'
alias ggpf='git push --force-with-lease origin "$(gbcurrent)"'
alias gprom='git pull --rebase --autostash --stat origin "$(gbdefault)"'
alias grbi='git rebase --interactive'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias grbq='git rebase --quit'
alias grbim='git rebase --interactive --autostash --autosquash "$(gbdefault)"'
alias gum='git fetch origin "$(gbdefault)":"$(gbdefault)"'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias gclean='git clean -d --interactive'

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

#!/usr/bin/env zsh

# Will return non-zero status if the current directory is not managed by git
is_in_git_repo() {
	git rev-parse HEAD >/dev/null 2>&1
}

export FZF_DEFAULT_OPTS="--bind ctrl-u:preview-page-up --bind ctrl-d:preview-page-down --bind ctrl-/:toggle-preview"
__fzf_down() {
	zle reset-prompt
	_fzf_complete \
		--height '50%' \
		--min-height 20 \
		--border \
		"$@"
}

# `ga **<Tab>`
_fzf_complete_ga() {
	is_in_git_repo || return

	__fzf_down \
		--multi \
		--preview 'git diff --color=always -- {}' \
		--preview-window 'top:70%' \
		-- "$@" < <(
			git add --intent-to-add --all

			changed_files="$(git diff --name-only)"
			[[ -z "$changed_files" ]] && exit 2

			echo "$changed_files"
		)
}
# `gc **<Tab>`
_fzf_complete_gc() {
	is_in_git_repo || return

	__fzf_down \
		--multi \
		--preview 'git diff --color=always --staged -- {}' \
		--preview-window 'top:70%' \
		-- "$@" < <(
			changed_files="$(git diff --name-only --staged)"
			[[ -z "$changed_files" ]] && exit 2

			echo "$changed_files"
		)
}
# `gco **<Tab>`
_fzf_complete_gco() {
	is_in_git_repo || return

	__fzf_down \
		--preview 'git diff --stat --color=always origin/master {}' \
		--preview-window 'top:75%' \
		-- "$@" < <(
			git fetch --all --prune --quiet
			git branch --all --sort=-committerdate --format='%(refname:short)'
		)
}
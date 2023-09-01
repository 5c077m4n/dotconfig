#!/usr/bin/env zsh

# Will return non-zero status if the current directory is not managed by git
is_in_git_repo() {
	git rev-parse HEAD >/dev/null 2>&1
}

export FZF_DEFAULT_OPTS="--bind ctrl-u:preview-page-up --bind ctrl-d:preview-page-down --bind ctrl-/:toggle-preview"
# Use fd (https://github.com/sharkdp/fd) instead of the default find command for listing path candidates.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

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
_fzf_complete_gco_post() {
	local branch=$1
	if [[ "$branch" == "origin/"* ]]; then
		echo "--track $branch"
	else
		echo $branch
	fi
}
# `nr **<Tab>`
_fzf_complete_nr() {
	is_in_git_repo && [[ -f package.json ]] || return

	__fzf_down \
		--preview "jq -r '.scripts.\"{}\"' package.json | bat --force-colorization --style='plain' --language='bash'" \
		--preview-window 'top:25%' \
		-- "$@" < <(
			jq -r ".scripts | keys | .[]" package.json
		)
}
# `npm run **<Tab>`
_fzf_complete_npm () {
	is_in_git_repo && [[ -f package.json ]] || return

	local args="$*"
	if [[ $args == 'npm run '* ]]; then
		__fzf_down \
			--preview "jq -r '.scripts.\"{}\"' package.json | bat --force-colorization --style='plain' --language='bash'" \
			--preview-window 'top:25%' \
			-- "$@" < <(
				jq --raw-output ".scripts | keys | .[]" package.json
			)
	else
		eval "zle ${fzf_default_completion:-expand-or-complete}"
	fi
}

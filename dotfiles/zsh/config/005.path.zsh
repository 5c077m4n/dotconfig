[[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]] && path+=("${KREW_ROOT:-$HOME/.krew}/bin") || true
[[ -d "${GOBIN}" ]] && path+=("$GOBIN") || true
[[ -x "${HOME}/.emacs.d/bin/doom" ]] && path+=("~/.emacs.d/bin/") || true

[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env" || true

path+=("${HOME}/.local/bin")
cdpath+=("${HOME}/repos")

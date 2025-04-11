if (( $+commands[pyenv] )); then
	export PYENV_ROOT="${XDG_CACHE_HOME:-${HOME}/.cache}/pyenv"

	[[ -d "${PYENV_ROOT}/bin" ]] && export PATH="${PYENV_ROOT}/bin:${PATH}"
	eval "$(pyenv init -)"
fi

typeset -UT PATH path
path=($path "${HOME}/.local/bin")
# Like `PATH` but for the command completions
typeset -UT FPATH fpath
# Like `PATH` but for the `cd` command (the first empty string is required)
typeset -UT CDPATH cdpath
cdpath=("" "${HOME}/repos")
# Like `PATH` but for the `man` command
typeset -UT MANPATH manpath
manpath=("/usr/local/man" $manpath)

if [[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]]; then
	path+=("${KREW_ROOT:-$HOME/.krew}/bin")
fi

export PATH
export FPATH
export CDPATH
export MANPATH

if (( $+commands[emacs] )); then
	export DOOMDIR="${HOME}/.config/doom"

	if [[ ! -d ~/.emacs.d/ ]]; then
		git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
		#~/.emacs.d/bin/doom install
	fi
fi

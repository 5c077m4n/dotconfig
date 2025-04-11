# Homebrew init
export HOMEBREW_BIN="/opt/homebrew/bin/brew"
if [[ -x "$HOMEBREW_BIN" ]]; then
	eval "$("$HOMEBREW_BIN" shellenv)"

	# Use gnu tools as default
	export HOMEBREW_PREFIX="$("$HOMEBREW_BIN" --prefix)"
	for gnu_bin_dir in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do
		[[ -d $gnu_bin_dir ]] && export PATH="${gnu_bin_dir}:${PATH}"
	done
	unset gnu_bin_dir

	export PATH="/opt/homebrew/bin:${PATH}"
	export FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"

	if [[ -d "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk" ]]; then
		# Gcloud init
		export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/.config/gcloud/application_default_credentials.json"
		source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
		source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
	fi
fi

# Init starship
eval "$(starship init zsh)"

# Autocompletion
autoload -Uz compinit
compinit

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
typeset -U PATH path
path=(
	$path
	"${HOME}/.local/bin"
	"${HOME}/.yarn/bin"
)
export PATH

# Like `PATH` but for the `cd` command
export CDPATH=":$HOME/.local/share:$HOME/Programming/tl:$HOME/Programming/other"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
#CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
#DISABLE_AUTO_UPDATE="true"

#Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if pasting URLs and other text is messed up.
#DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
#DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
#DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
#DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git kubectl zsh-autosuggestions zsh-syntax-highlighting zsh-aliases-exa)
source "${ZSH}/oh-my-zsh.sh"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG="en_US.UTF-8"
export EDITOR="nvim"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
#export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
#alias zshconfig="mate ~/.zshrc"
#alias ohmyzsh="mate ~/.oh-my-zsh"

[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# Kubectl zsh completion
[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

[[ -f "${ZDOTDIR}/aliases" ]] && source "${ZDOTDIR}/aliases"
[[ -f "${ZDOTDIR}/fzf-functions" ]] && source "${ZDOTDIR}/fzf-functions"
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"
[[ -f "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

# Leatherman
[[ -f "${XDG_DATA_HOME-$HOME/.local/share}/leatherman/source-me.sh" ]] && source "${XDG_DATA_HOME-$HOME/.local/share}/leatherman/source-me.sh"

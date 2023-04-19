# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
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

# Homebrew init
brew_bin="/opt/homebrew/bin/brew"
if [[ -x "$brew_bin" ]]; then
	export HOMEBREW_NO_ANALYTICS=1

	eval "$($brew_bin shellenv)"

	path+=("/opt/homebrew/bin")
	fpath+=("${HOMEBREW_PREFIX}/share/zsh/site-functions")

	# Use GNU tools as default
	export HOMEBREW_PREFIX="$($brew_bin --prefix)"
	for gnu_bin_dir in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do
		[[ -d $gnu_bin_dir ]] && path+=("$gnu_bin_dir")
	done
	unset gnu_bin_dir

	if [[ -d "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk" ]]; then
		# Gcloud init
		export USE_GKE_GCLOUD_AUTH_PLUGIN=True
		export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/.config/gcloud/application_default_credentials.json"
		source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
		source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
	fi
fi
unset brew_bin

export PATH
export FPATH
export CDPATH
export MANPATH

# Uncomment the following line to use case-sensitive completion.
#CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

#Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
#export UPDATE_ZSH_DAYS=7

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
plugins=(fzf rust zsh-autosuggestions zsh-syntax-highlighting)

[[ -f "${ZDOTDIR}/oh-my-zsh-upsert.zsh" ]] && source "${ZDOTDIR}/oh-my-zsh-upsert.zsh"
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

# Init starship
eval "$(starship init zsh)"

[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# Completions
## Kubectl
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion zsh)
## K3D
[[ -x "$(command -v k3d)" ]] && source <(k3d completion zsh)

# Add krew to path
[[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]] && path+=("${KREW_ROOT:-$HOME/.krew}/bin")

[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"
[[ -f "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

# Leatherman
[[ -f "$HOME/repos/leatherman/source-me.sh" ]] && source "$HOME/repos/leatherman/source-me.sh"

[[ -f "${ZDOTDIR}/aliases.zsh" ]] && source "${ZDOTDIR}/aliases.zsh"
[[ -f "${ZDOTDIR}/fzf-functions.zsh" ]] && source "${ZDOTDIR}/fzf-functions.zsh"

# Autocompletion
autoload -Uz compinit
compinit
# Expand alias on `<C-x>a`/`<Tab>`
bindkey "^Xa" _expand_alias
zstyle ':completion:*' completer _expand_alias _complete _ignored
zstyle ':completion:*' regular true

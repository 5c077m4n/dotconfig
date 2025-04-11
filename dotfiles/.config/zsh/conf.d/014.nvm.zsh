export NVM_DIR="$XDG_DATA_HOME/nvm/$(uname -m)"

if [[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]]; then
	. "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"

	# Auto load current dir's node version
	autoload -U add-zsh-hook

	load-nvmrc() {
		local nvmrc_path
		nvmrc_path="$(nvm_find_nvmrc)"

		if [[ -n "$nvmrc_path" ]]; then
			local nvmrc_node_version
			nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

			if [[ "$nvmrc_node_version" = "N/A" ]]; then
				nvm install
			elif [[ "$nvmrc_node_version" != "$(nvm version)" ]]; then
				nvm use
			fi
		elif [[ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ]] && [[ "$(nvm version)" != "$(nvm version default)" ]]; then
			echo "Reverting to nvm default version"
			nvm use default
		fi
	}

	add-zsh-hook chpwd load-nvmrc
	load-nvmrc
fi

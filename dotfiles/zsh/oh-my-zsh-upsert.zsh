if [[ ! -f "${ZSH}/oh-my-zsh.sh" ]]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [[ ! -d "${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-autosuggestions" ]]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-autosuggestions"
fi
if [[ ! -d "${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-syntax-highlighting" ]]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-syntax-highlighting"
fi

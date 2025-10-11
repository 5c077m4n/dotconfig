function supdate --description 'Run a full system update'
    nvim --headless +"Lazy! sync" +qa
    __commit_if_needed ~/workspace/dotconfig/dotfiles/.config/nvim/lazy-lock.json

    if type --query nix && test -f ~/workspace/dotconfig/flake.nix
        nix flake update --flake ~/workspace/dotconfig/

        if type --query darwin-rebuild
            sudo darwin-rebuild switch --flake ~/workspace/dotconfig#roee@macos
        else if type --query nixos-rebuild
            sudo nixos-rebuild switch --flake ~/workspace/dotconfig/#roee@nixos-vivo
        else if type --query home-manager
            home-manager switch --flake ~/workspace/dotconfig/#roee@ubuntu-vivo
        end

        __commit_if_needed ~/workspace/dotconfig/flake.lock
    else if type --query brew
        brew update
        brew bundle install
    else if type --query pacman
        sudo pacman -Syu
    else if type --query pkg
        pkg update
        pkg upgrade
    else if type --query apk
        sudo apk update
        sudo apk upgrade
    end

    if type --query apt
        if type --query nala
            sudo nala upgrade --update
        else
            sudo apt upgrade --update
        end
    end

    if type --query fisher
        fisher update
    end
end

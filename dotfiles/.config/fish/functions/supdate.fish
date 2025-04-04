function supdate --description 'Run a full system update'
    if type --query nix && test -f ~/workspace/dotconfig/flake.nix
        nix flake update --flake ~/workspace/dotconfig/

        if type --query nix-darwin
            sudo nix-darwin switch --flake ~/workspace/dotconfig/#roee@macos
        else if type --query nixos-rebuild
            sudo nixos-rebuild switch --flake ~/workspace/dotconfig/#roee@nixos-vivo
        else if type --query home-manager
            home-manager switch --flake ~/workspace/dotconfig/#roee@ubuntu-vivo
        end
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
        sudo apt update
        sudo apt upgrade --yes
        sudo apt autoremove --yes
    end

    nvim --headless +"Lazy! sync" +qa
    type --query fisher && fisher update
end

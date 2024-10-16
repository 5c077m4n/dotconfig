function supdate --description 'Run a full system update'
    if type --query darwin-rebuild && test -f ~/workspace/dotconfig/dotfiles/nix/darwin/flake.nix
        nix flake update ~/workspace/dotconfig/dotfiles/nix/darwin
        darwin-rebuild switch --flake ~/workspace/dotconfig/dotfiles/nix/darwin
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
    else if type --query apt
        sudo apt update
        sudo apt upgrade
    end

    nvim --headless +"Lazy! sync" +qa
    type --query rustup && rustup upgrade
    type --query fisher && fisher update
end

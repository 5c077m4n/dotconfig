function supdate --description 'Run a full system update'
    if type --query darwin-rebuild && test -f ~/workspace/dotconfig/flake.nix
        nix flake update ~/workspace/dotconfig/
        darwin-rebuild switch --flake ~/workspace/dotconfig/
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
    type --query fisher && fisher update
end

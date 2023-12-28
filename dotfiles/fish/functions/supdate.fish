function supdate --description 'Run a full system update'
    if command --query brew
        brew update
        brew bundle install
    else if command --query pacman
        sudo pacman -Syu
    else if command --query pkg
        pkg update
        pkg upgrade
    else if command --query apk
        sudo apk update
        sudo apk upgrade
    else if command --query apt
        sudo apt update
        sudo apt upgrade
    end

    nvim --headless +"Lazy! sync" +qa
    type --query rustup && rustup upgrade
    type --query fisher && fisher update
end

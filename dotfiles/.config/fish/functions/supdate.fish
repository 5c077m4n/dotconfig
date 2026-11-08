function supdate --description 'Run a full system update'
    nvim --headless +"Lazy! sync" +qa
    __commit_if_needed ~/workspace/dotconfig/dotfiles/.config/nvim/lazy-lock.json
    nvim --headless +MasonPackagesUpdateAll +qa

    nvim --headless +'lua
        local registry = require("mason-registry")
        local refreshed = false
        registry.refresh(function() refreshed = true end)
        vim.wait(60000, function() return refreshed end)

        local pending = 0
        for _, pkg in ipairs(registry.get_installed_packages()) do
            local installed = pkg:get_installed_version()
            local latest = pkg:get_latest_version()

            if installed ~= latest then
                pending = pending + 1
                print(("Updating %s %s -> %s\n"):format(pkg.name, installed, latest))
                pkg:install({}, function(success)
                    if not success then print(("Failed updating %s\n"):format(pkg.name)) end
                    pending = pending - 1
                end)
            end
        end
        vim.wait(600000, function() return pending == 0 end)
    ' +qa

    if type --query nix && test -f ~/.config/nix/flake.nix
        nix flake update --flake ~/.config/nix/

        if type --query darwin-rebuild
            sudo darwin-rebuild switch --flake ~/.config/nix#roee@macos
        else if type --query nixos-rebuild
            sudo nixos-rebuild switch --flake ~/.config/nix#roee@nixos
        else if type --query home-manager
            home-manager switch --flake ~/.config/nix#roee@ubuntu
        end

        __commit_if_needed ~/workspace/dotconfig/dotfiles/.config/nix/flake.lock
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
    if type --query gh
        gh extension upgrade --all
    end
    if type --query pi
        pi update --extensions
    end
end

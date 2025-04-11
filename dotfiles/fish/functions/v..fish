function v. --description "Open Neovim in the current directory and if inside a poetry project activate its env"
    if type --query poetry && test -f poetry.lock
        . (poetry env info --path)/bin/activate.fish
    end

    nvim . $argv
    type --query deactivate && deactivate
end

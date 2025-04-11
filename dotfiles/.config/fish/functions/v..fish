function v. --wraps nvim --description "Open Neovim in the current directory and if inside a poetry project activate its virtual environment"
    if type --query poetry && test -f poetry.lock
        . (poetry env info --path)/bin/activate.fish
        nvim . $argv
        deactivate
    else
        nvim . $argv
    end
end

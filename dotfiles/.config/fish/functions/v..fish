function v. --wraps nvim --description "Open Neovim in the current directory and if inside a poetry project activate its virtual environment"
    if type --query poetry && test -f poetry.lock
        source (poetry env info --path)/bin/activate.fish
        nvim . $argv
        deactivate
    else if test -f ./.venv/bin/activate.fish
        source ./.venv/bin/activate.fish
        nvim . $argv
        deactivate
    else
        nvim . $argv
    end
end

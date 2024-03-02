function v.
    if type --query poetry && test -f poetry.lock
        . (poetry env info --path)/bin/activate.fish
    end

    nvim . $argv
    type --query deactivate && deactivate
end

function gbdefault --description 'Get the default git branch name'
    command git rev-parse --git-dir &>/dev/null || return 1

    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}
        if git show-ref --quiet --verify $ref
            echo (string split --right --max 1 '/' $ref)[-1]
            return
        end
    end

    echo master
end

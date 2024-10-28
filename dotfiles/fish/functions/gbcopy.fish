function gbcopy --description "Copy current git branch name to clipboard"
    git branch --show-current $argv | pbcopy
end

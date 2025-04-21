function gaa --wraps 'git add' --description "Git add all"
    git add --all --verbose $argv
end

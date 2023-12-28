function ggpf --description 'Git force push into current branch'
    git push --force-with-lease origin (git branch --show-current) $argv
end

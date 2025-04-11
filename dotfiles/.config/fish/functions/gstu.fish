function gstu --wraps "git status"
    git status --untracked-files $argv
end

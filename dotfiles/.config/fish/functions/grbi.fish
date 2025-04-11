function grbi --wraps "git rebase"
    git rebase --interactive --autostash --autosquash $argv
end

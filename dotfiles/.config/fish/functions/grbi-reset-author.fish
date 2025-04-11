function grbi-reset-author --wraps "git rebase" --description "Git rebase to reset the author data"
    git rebase --interactive --autostash --autosquash --exec 'git commit --amend --reset-author --no-edit' $argv
end

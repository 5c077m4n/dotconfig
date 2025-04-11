function grbi-reset-author --description "Git rebase to reset the author data"
    git rebase --interactive --autostash --autosquash --exec 'git commit --amend --reset-author --no-edit' $argv
end

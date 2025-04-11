function grbim --description "Git rebase from the project's start"
    git rebase --interactive --autostash --autosquash --root $argv
end

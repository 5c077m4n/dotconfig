function grbim --wraps "git rebase" --description 'Git rebase from the default branch'
    git rebase --interactive --autostash --autosquash (gbdefault) $argv
end

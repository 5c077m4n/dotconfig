function grba --wraps "git rebase" --description 'Abort the current git rebase'
    git rebase --abort
end

function ghsra --wraps "gh stack rebase --abort"
    gh stack rebase --abort $argv
end

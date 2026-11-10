function ghsrc --wraps "gh stack rebase --continue"
    gh stack rebase --continue $argv
end

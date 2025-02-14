function gc! --wraps "git commit"
    git commit --verbose --amend $argv
end

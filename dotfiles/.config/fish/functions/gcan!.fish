function gcan! --wraps "git commit"
    git commit --verbose --amend --all --no-edit $argv
end

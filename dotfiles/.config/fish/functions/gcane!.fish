function gcan! --wraps "git commit"
    git commit --verbose --amend --all --no-edit --allow-empty
end

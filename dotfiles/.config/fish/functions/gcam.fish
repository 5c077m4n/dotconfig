function gcam --wraps "git commit"
    git commit --all --message $argv
end

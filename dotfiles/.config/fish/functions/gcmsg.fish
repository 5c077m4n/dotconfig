function gcmsg --wraps "git commit" --description 'Git commit with a message'
    git commit --message $argv
end

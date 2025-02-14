function gupa --wraps "git pull"
    git pull --autostash --stat origin (git branch --show-current)
end

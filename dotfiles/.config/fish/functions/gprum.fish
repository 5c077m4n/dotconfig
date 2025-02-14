function gprum --wraps "git pull" --description "Git pull from the upstream's default branch"
    git pull --rebase --autostash --stat upstream (gbdefault)
end

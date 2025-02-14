function gprom --wraps "git pull" --description 'Git pull from the default branch'
    git pull --rebase --autostash --stat origin (gbdefault)
end

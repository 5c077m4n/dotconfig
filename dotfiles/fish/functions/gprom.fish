function gprom --description 'Git pull from the default branch'
    git pull --rebase --autostash --stat origin (gbdefault)
end

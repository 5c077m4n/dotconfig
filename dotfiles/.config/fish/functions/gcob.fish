function gcob --wraps "git checkout" --description 'Git checkout into a new branch from the default'
    git checkout -b $argv (gbdefault)
end

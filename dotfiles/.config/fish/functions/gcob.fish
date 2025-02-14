function gcob --wraps "git checkout" --description 'Git checkout into a new branch'
    git checkout -b $argv
end

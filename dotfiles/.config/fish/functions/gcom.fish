function gcom --wraps "git checkout" --description 'Git checkout into the default branch'
    git checkout (gbdefault) $argv
end

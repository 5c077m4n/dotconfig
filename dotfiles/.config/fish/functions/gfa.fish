function gfa --wraps "git fetch" --description 'Git fetch all branches metadata'
    git fetch --all --prune
end

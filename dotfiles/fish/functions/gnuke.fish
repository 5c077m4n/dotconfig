function gnuke --description "Nuke current work dir"
    git reset --hard
    git clean -dffx
end

function ranger --wraps ranger --description 'Run ranger without nested instances'
    if test -z "$RANGER_LEVEL"
        command ranger $argv
    else
        return
    end
end

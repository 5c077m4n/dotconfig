function gds --wraps "git diff" --description 'Show git diff of staged changes'
    git diff --staged $argv
end

function __commit_if_needed --argument-names file_to_commit --description 'Commit a file/dir only if a change has been made'
    if ! git diff --exit-code $file_to_commit &>/dev/null
        git add $file_to_commit
        git commit --message "Bump $(basename $file_to_commit)" $file_to_commit
    end
end

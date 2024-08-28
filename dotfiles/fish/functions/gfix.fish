function gfix --description 'Fixup staged changes into a prev commit'
    set --local rev (git log --oneline | fzf --reverse --preview 'echo {} | awk \'{print $1}\' | xargs git show --color=always' | awk '{print $1}')
    test -z "$rev" && return 0

    git commit --fixup $rev
    git rebase --autostash --autosquash --interactive "$rev^"
end

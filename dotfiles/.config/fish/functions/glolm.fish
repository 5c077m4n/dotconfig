function glolm --wraps "git log" --description 'Show a pretty git log of commits since the default branch'
    git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" origin/(gbdefault).. $argv
end

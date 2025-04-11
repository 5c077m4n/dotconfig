function glol --wraps "git log" --description 'Show a pretty git log'
    git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" $argv
end

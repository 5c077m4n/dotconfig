function glols --wraps "git log" --description 'Show a pretty git log of commits and files'
    git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat $argv
end

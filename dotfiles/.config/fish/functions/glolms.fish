function glolms --description 'Show a pretty git log of commits and files since the default branch'
    git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat origin/(gbdefault).. $argv
end

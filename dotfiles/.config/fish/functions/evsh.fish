function evsh --description "Restart the SSH agent"
    eval (ssh-agent -c)
end

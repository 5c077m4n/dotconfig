function killport
    for port in $argv
        for pid in (sudo lsof -ti ":$port")
            ps -p $pid
            kill -9 $pid
        end
    end
end

if type --query go
    set --export --global GOPATH "$XDG_DATA_HOME/go"
    set --export --global GOBIN "$GOPATH/bin"

    fish_add_path $GOBIN
end

if type --query pyenv
    set --global --export PYENV_ROOT "$XDG_DATA_HOME/pyenv/$(uname -m)"
    fish_add_path $PYENV_ROOT/bin

    pyenv init - | source
end

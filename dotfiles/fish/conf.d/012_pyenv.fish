if type --query pyenv
    set --global --export PYENV_ROOT $XDG_CACHE_HOME/pyenv
    fish_add_path $PYENV_ROOT/bin

    pyenv init - | source
end

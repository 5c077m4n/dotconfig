if type --query starship
    set --export --global STARSHIP_CONFIG $HOME/.config/starship/config.toml
    starship init fish | source
end

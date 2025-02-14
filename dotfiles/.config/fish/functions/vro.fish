function vro --wraps nvim --description 'Open a read only instance on Neovim'
    nvim -mR $argv
end

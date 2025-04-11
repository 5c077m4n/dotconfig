set --local brew_bin_path /opt/homebrew/bin/brew

if test -x $brew_bin_path
    set --export --global HOMEBREW_NO_ANALYTICS 1
    set --export --global HOMEBREW_PREFIX ($brew_bin_path --prefix)
    set --export --global HOMEBREW_BUNDLE_FILE "$HOME/repos/dotconfig/assets/macos/Brewfile"

    eval ($brew_bin_path shellenv)
end

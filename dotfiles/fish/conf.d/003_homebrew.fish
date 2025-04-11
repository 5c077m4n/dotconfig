set --export --global HOMEBREW_NO_ANALYTICS 1
set --export --global HOMEBREW_BUNDLE_FILE "$HOME/.config/homebrew/Brewfile"

set --local brew_bin_arm64 /opt/homebrew/bin/brew
set --local brew_bin_x86 /usr/local/Homebrew/bin/brew

if test -x $brew_bin_x86 -a (uname -m) != arm64
    eval ($brew_bin_x86 shellenv)
else if test -x $brew_bin_arm64
    eval ($brew_bin_arm64 shellenv)
end

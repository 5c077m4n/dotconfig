set --export --global HOMEBREW_NO_ANALYTICS 1

set --local nixd_init /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish

if test -e $nixd_init
    . $nixd_init
else
    set --export --global HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/homebrew/Brewfile"

    set --local brew_bin_arm64 /opt/homebrew/bin/brew
    set --local brew_bin_x86 /usr/local/Homebrew/bin/brew

    if test -x $brew_bin_x86 -a (uname -m) != arm64 -a (arch) != arm64
        $brew_bin_x86 shellenv | source
    else if test -x $brew_bin_arm64
        $brew_bin_arm64 shellenv | source
    end

    fish_add_path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
end

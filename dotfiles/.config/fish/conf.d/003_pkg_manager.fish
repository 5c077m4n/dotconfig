set --local nixd_init /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
if test -e $nixd_init
    . $nixd_init

    set --local per_user_pkgs "/etc/profiles/per-user/$USER/bin/"
    if test -d $per_user_pkgs
        fish_add_path $per_user_pkgs
    end
end

set --local brew_bin /opt/homebrew/bin/brew
if test -x $brew_bin
    set --export --global HOMEBREW_NO_ANALYTICS 1
    set --export --global HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/homebrew/Brewfile"

    $brew_bin shellenv | source

    if test -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
        fish_add_path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
    end
end

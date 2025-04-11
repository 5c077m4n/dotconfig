set --global --export XDG_CONFIG_HOME "$HOME/.config"
set --global --export XDG_CACHE_HOME "$HOME/.cache"
set --global --export XDG_DATA_HOME "$HOME/.local/share"
set --global --export XDG_STATE_HOME "$HOME/.local/state"

set --global --export --path XDG_DATA_DIRS /usr/local/share /usr/share
set --global --export --path XDG_CONFIG_DIRS /etc/xdg

set --global --export XDG_DESKTOP_DIR "$HOME/Desktop"
set --global --export XDG_DOCUMENTS_DIR "$HOME/Documents"
set --global --export XDG_DOWNLOAD_DIR "$HOME/Downloads"
set --global --export XDG_MUSIC_DIR "$HOME/Music"
set --global --export XDG_PICTURES_DIR "$HOME/Pictures"
set --global --export XDG_PUBLICSHARE_DIR "$HOME/Public"
set --global --export XDG_TEMPLATES_DIR "$HOME/Templates"
set --global --export XDG_VIDEOS_DIR "$HOME/Videos"
set --global --export XDG_RUNTIME_DIR "/tmp/user/$(id -u)"

if ! test -d "$XDG_RUNTIME_DIR"
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 0700 "$XDG_RUNTIME_DIR"
end

for xdg_dir in (printenv | grep '^XDG_.*_HOME=' | sed 's/.*=//')
    if ! test -d "$xdg_dir"
        mkdir -p "$xdg_dir"
    end
end

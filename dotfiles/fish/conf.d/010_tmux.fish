set --local tmux_plugin_path $XDG_STATE_HOME/tmux/plugins/
set --local tpm_path $tmux_plugin_path/tpm/

if type --query tmux && ! test -d $tpm_path
    mkdir -p $tmux_plugin_path
    git -C $tmux_plugin_path clone https://github.com/tmux-plugins/tpm
end

function fzf --wraps fzf
    set --export --local FZF_DEFAULT_COMMAND 'fd --type file --strip-cwd-prefix --hidden --follow --exclude .git'
    command fzf --bind 'ctrl-u:preview-page-up' --bind 'ctrl-d:preview-page-down' --bind 'ctrl-/:toggle-preview' $argv
end

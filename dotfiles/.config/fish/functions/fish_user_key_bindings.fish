function fish_user_key_bindings
    set --global fish_key_bindings fish_vi_key_bindings

    bind \cd exit
    bind --mode insert \cc kill-whole-line repaint
    bind --mode insert \cx\ce edit_command_buffer

    bind --mode insert \cp up-or-search
    bind --mode insert \cn down-or-search

    bind --mode insert \ef forward-word
    bind --mode insert \eb backward-word

    bind --erase --preset \ee
    bind --erase --preset \ev
    bind --erase --preset --mode insert \ee
    bind --erase --preset --mode insert \ev
    bind --erase --preset --mode visual \ee
    bind --erase --preset --mode visual \ev
end

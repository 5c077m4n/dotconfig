# Add the repos dir into the quick cd lookup path
set --append CDPATH ~/repos/

fish_add_path $HOME/.local/bin/
if test -d $HOME/.cargo/bin/
    fish_add_path $HOME/.cargo/bin/
end

vardedup PATH CDPATH MANPATH

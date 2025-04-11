# Add the repos dir into the quick cd lookup path
set --append CDPATH ~/repos/
# Append the cargo bin dir into $PATH if it exists
if test -d $HOME/.cargo/bin/
    fish_add_path $HOME/.cargo/bin/
end

vardedup PATH CDPATH MANPATH

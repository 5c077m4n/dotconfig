set --export --global fisher_path "$XDG_DATA_HOME/fisher"
<<<<<<< HEAD
=======

set --global fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set --global fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    source $file
end
>>>>>>> 5d60e04 (fixup! Add fish config)

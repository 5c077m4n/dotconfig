function vardedup --description 'Remove duplicates from environment variables'
    if test (count $argv) = 1
        set --local clean_var

        for v in $$argv
            if not contains -- $v $clean_var
                set --append clean_var $v
            end
        end
        set $argv $clean_var
    else
        for a in $argv
            vardedup $a
        end
    end
end

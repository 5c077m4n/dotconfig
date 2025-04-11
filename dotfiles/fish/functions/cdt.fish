function cdt --description "Chage dir into temp"
    cd (mktemp --directory)
end

function graphify --wraps graphify --description "A tool to create an AST graph from the current codebase"
    if not uvx --offline --from graphifyy graphify --version &>/dev/null
        uvx --from graphifyy --with sql graphify --version >/dev/null
    end

    set --local project_root (pwd)
    set --local data_dir $project_root/graphify-out
    set --local uv_cache (realpath "$HOME/.cache/uv")
    set --local uv_data (realpath "$HOME/.local/share/uv")

    sandbox-exec \
        -D PROJECT_ROOT=$project_root \
        -D DATA_DIR=$data_dir \
        -D UV_CACHE=$uv_cache \
        -D UV_DATA=$uv_data \
        -D HOME=$HOME \
        -D TMPDIR=$TMPDIR \
        -p '
             (version 1)
             (allow default)
             (deny network*)
             (deny file-write*
                 (require-not
                     (require-any
                         (subpath (param "DATA_DIR"))
                         (subpath (param "UV_CACHE"))
                         (subpath (param "UV_DATA"))
                         (subpath (param "TMPDIR"))
                     )
                 )
             )
             (deny file-read*
                 (subpath (string-append (param "HOME") "/.ssh"))
                 (subpath (string-append (param "HOME") "/.aws"))
                 (subpath (string-append (param "HOME") "/.gnupg"))
                 (subpath (string-append (param "HOME") "/.config/gh"))
                 (subpath (string-append (param "HOME") "/Library/Keychains"))
             )
         ' uvx --offline --from graphifyy graphify $argv

    echo "*" >"$data_dir/.gitignore"
end

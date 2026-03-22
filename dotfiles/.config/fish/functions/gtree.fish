function __git_worktree_install_deps
    set --local scan_dirs . frontend front client web ui backend back server api app src

    set --local dir
    for dir in $scan_dirs
        if not test -d "$dir"
            continue
        end

        if test -f "$dir/pnpm-lock.yaml"
            pnpm install -C "$dir"
        else if test -f "$dir/yarn.lock"
            yarn --cwd "$dir" install
        else if test -f "$dir/bun.lockb" -o -f "$dir/bun.lock"
            bun install --cwd "$dir"
        else if test -f "$dir/package-lock.json"
            npm clean-install --prefix "$dir"
        else if test -f "$dir/poetry.lock"
            fish -c "cd $dir && poetry install"
        else if test -f "$dir/Pipfile.lock" -o -f "$dir/Pipfile"
            fish -c "cd $dir && pipenv install"
        else if test -f "$dir/requirements.txt"
            echo "Creating venv and installing dependencies in $dir with pip..."
            python3 -m venv "$dir/.venv"
            fish -c "source $dir/.venv/bin/activate.fish && pip install -r $dir/requirements.txt"
        else if test -f "$dir/go.mod"
            fish -c "cd $dir && go mod tidy"
        else
            continue
        end

        if test $status -eq 0
            echo "✓ Installed dependencies in $dir"
        else
            echo "✗ Failed to install dependencies in $dir"
        end
    end
end

function __git_worktree_add
    if test (count $argv) -lt 1
        echo "Usage: gtree add <branch> [<branch>...]"
        echo "Example: gtree add feature-login feature-signup bugfix-auth"
        return 1
    end

    set --local project_name (basename (dirname (git rev-parse --path-format=absolute --git-common-dir)))

    if test -z "$project_name"
        echo "Error: Could not determine project name"
        return 1
    end

    set --local branch
    for branch in $argv
        set --local worktree_path "../$(echo "$project_name"__"$branch" | string escape --style='var')"

        echo "Creating worktree: $worktree_path for branch: $branch"
        if git rev-parse --verify $branch >/dev/null 2>&1
            git worktree add $worktree_path $branch
        else
            git worktree add -b $branch $worktree_path
        end

        if test $status -eq 0
            echo "✓ Successfully created worktree at $worktree_path"
            cd $worktree_path
            __git_worktree_install_deps
        else
            echo "✗ Failed to create worktree for $branch"
        end
        echo ""
    end
end

function __git_worktree_list
    if test (count $argv) -ge 1
        git worktree list | string match -i "*$argv[1]*"
    else
        git worktree list
    end
end

function __git_worktree_remove
    set --local worktrees (git worktree list --porcelain | awk '/^worktree/ {path=$2; print path}' | tail -n +2)

    if test -z "$worktrees"
        echo "No more worktrees to remove."
        return 0
    end

    set --local fzf_query
    if test (count $argv) -ge 1
        set fzf_query --query "$argv[1]"
    end

    set --local selected (printf "%s\n" $worktrees | \
          fzf --prompt="Select worktree(s) to remove: " \
              --multi \
              --height=40% \
              --layout=reverse \
              --border \
              $fzf_query \
              --preview='echo {} | xargs -I[] git -C [] show (gbdefault)..HEAD' \
              --preview-window=right:50%)

    if test -z "$selected"
        echo "No worktree selected."
        return 0
    end

    set --local worktree_path
    for worktree_path in $selected
        if string match -q -- "$worktree_path*" $PWD
            set --local main_worktree (git worktree list --porcelain | awk '/^worktree/ {print $2; exit}')
            echo "Currently in worktree being removed, changing to $main_worktree"
            cd $main_worktree
        end

        echo "Removing worktree: $worktree_path"
        if git worktree remove $worktree_path
            echo "✓ Successfully removed $worktree_path"
        else
            echo "✗ Failed to remove $worktree_path"
        end
        echo ""
    end
end

function __git_worktree_cd
    set --local worktrees (git worktree list --porcelain | awk '/^worktree/ {path=$2; print path}')

    if test -z "$worktrees"
        echo "No worktrees found."
        return 0
    end

    set --local worktree_path (printf "%s\n" $worktrees | \
          fzf --prompt="Select worktree: " \
              --height=40% \
              --layout=reverse \
              --border \
              --preview='echo {} | xargs -I[] git -C [] show (gbdefault)..HEAD' \
              --preview-window=right:50%)

    if test -z "$worktree_path"
        echo "No worktree selected."
        return 0
    end

    cd $worktree_path
end

function __git_worktree_help
    echo "Git Worktree Manager"
    echo ""
    echo "Usage: gtree <command> [arguments]"
    echo ""
    echo "Commands:"
    echo " add <branch> [<branch>...] # Create worktrees for one or more branches"
    echo " list # List all worktrees"
    echo " cd # Interactively select and cd into a worktree"
    echo " remove # Interactively remove a worktree using fzf"
    echo " help # Show this help message"
    echo ""
    echo "Examples:"
    echo "> gtree add feature-login"
    echo "> gtree add feature-login feature-signup bugfix-auth"
    echo "> gtree list"
    echo "> gtree remove"
end

function gtree --description "A util to manage git worktrees"
    set --local cmd $argv[1]

    switch $cmd
        case add
            __git_worktree_add $argv[2..]
        case list ls
            __git_worktree_list $argv[2..]
        case cd
            __git_worktree_cd $argv[2..]
        case remove rm
            __git_worktree_remove $argv[2..]
        case help -h --help
            __git_worktree_help
        case '*'
            echo "Error: Unknown command '$cmd'"
            __git_worktree_help
            return 1
    end
end

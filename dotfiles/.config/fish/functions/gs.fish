function gs --description 'Sync all git branches'
    git fetch --all --prune --prune-tags
    echo ""

    # Use | as the field separator since it won't appear in refs or track info
    git for-each-ref --format='%(refname:short)|%(upstream:short)|%(upstream:track)' refs/heads | while read -l line
        set -l parts (string split '|' -- $line)
        set -l branch $parts[1]
        set -l upstream $parts[2]
        set -l track $parts[3]

        if test -z "$upstream"
            echo "⊘ $branch (no upstream)"
            continue
        end

        if test -z "$track"
            echo "= $branch (up to date)"
            continue
        end

        if string match -q '*ahead*' -- $track
            echo "⚠ $branch (diverged or ahead — skipping)"
            continue
        end

        if string match -q '*behind*' -- $track
            set -l worktree (git worktree list --porcelain | awk -v b="refs/heads/$branch" '/^worktree/{wt=$2} /^branch/ && $2==b {print wt; exit}')

            if test -n "$worktree"
                set -l output (git -C "$worktree" merge --ff-only "$upstream" 2>&1)
                if test $status -eq 0
                    echo "✓ $branch (worktree: $worktree)"
                else
                    echo "✗ $branch (worktree: $worktree) — fast-forward failed:"
                    printf '    %s\n' $output
                end
            else
                if git update-ref "refs/heads/$branch" "$upstream" 2>/dev/null
                    echo "✓ $branch"
                else
                    echo "✗ $branch — could not update ref"
                end
            end
        end
    end
end

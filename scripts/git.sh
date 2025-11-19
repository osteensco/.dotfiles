#!/usr/bin/env bash



# git checkout to fzf select
gitco() {
    local branch
    branch=$(git branch --format='%(refname:short)' | fzf)
    if [[ -n "$branch" ]]; then
        git checkout "$branch"
    fi
}

# git push & set upstream
gitp() {
    git push -u origin $(git rev-parse --abbrev-ref HEAD)
}

# git branch delete using fzf multi-select
gitbd() {
    git branch -d $(git branch | fzf -m)
}

# git catch up local branch with remote of same name and rebase current branch to it
gitsync() {
    # default to 'main' if no argument is given
    local base_branch="${1:-main}"

    echo "Syncing current branch with '$base_branch' ..."

    # fetch the remote branch and update the local branch without switching
    if ! git fetch origin "$base_branch:$base_branch"; then
        echo "Error: Failed to fetch origin/$base_branch"
        return 1
    fi

    # rebase current branch on updated base branch
    if ! git rebase "$base_branch"; then
        echo "Error: Rebase failed"
        return 1
    fi
}



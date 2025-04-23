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

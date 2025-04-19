#!/usr/bin/env bash



# navigate to a directory and list its contents
cdls() {
    cd "$1" && ls -l
}
# create a directory and then navigate into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}


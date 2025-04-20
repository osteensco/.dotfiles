#!/usr/bin/env bash



# navigate to a directory and list its contents
ftls() {
    ft "$1" && ls -l
}
# create a directory and then navigate into it
mkft() {
    mkdir -p "$1" && ft "$1"
}
# create a directory, navigate in, and set to a fastTravelCLI key
ftnew() {
    mkft "$1" && ft -set "$2"
}

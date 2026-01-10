#!/usr/bin/env bash



# activate python virtual environment from list of available in current project
pytivate() {
    source ~/.local/bin/pytivate -y
}

# start ssh server
sshstart() {
    sudo systemctl start sshd && sudo systemctl status sshd
}

# stop ssh server
sshstop() {
    sudo systemctl stop sshd && sudo systemctl status sshd
}

# find and execute tmux_setup.sh
tmuxsetup() {
    echo "I still need to be implemented :("
}

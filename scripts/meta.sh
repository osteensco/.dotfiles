#!/usr/bin/env bash

# functions relating to shell session, environments, and similar



declare -A fn_meta_data_git
declare -A fn_meta_data_nav
declare -A fn_meta_data_meta

# git
fn_meta_data_git["gitco"]="git checkout to fzf select"
fn_meta_data_git["gitp"]="git push & set upstream"
fn_meta_data_git["gitbd"]="git branch delete using fzf multi-select"

# nav
fn_meta_data_nav["ftls"]="navigate to a directory and list it's contents"
fn_meta_data_nav["mkft"]="create a directory and then navigate to it"
fn_meta_data_nav["ftnew"]="create a directory, navigate in, and set to a fastTravelCLI key"

# meta
fn_meta_data_meta["fnls"]="show available custom functions"
fn_meta_data_meta["pytivate"]="activate python virtual environment from list of available in current project"
fn_meta_data_meta["sshstart"]="activate ssh server"


# show available custom functions
fnls() {

    showfunc(){
        printf "| %s\n" "$1: $2"
        
    }

    printf "\ngit\n"
    for key val in "${(@kv)fn_meta_data_git}"; do
        echo $(showfunc $key $val)
    done
    
    printf "\nnav\n"
    for key val in "${(@kv)fn_meta_data_nav}"; do
        echo $(showfunc $key $val)
    done
    
    printf "\nmeta\n"
    for key val in "${(@kv)fn_meta_data_meta}"; do
        echo $(showfunc $key $val)
    done

}


# activate python virtual environment from list of available in current project
pytivate() {
    source ~/.local/bin/pytivate -y
}


# activate ssh server
sshstart() {
    sudo systemctl start sshd
}

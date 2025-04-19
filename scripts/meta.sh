#!/usr/bin/env bash



declare -A fn_meta_data_git
declare -A fn_meta_data_nav
declare -A fn_meta_data_meta

# git
fn_meta_data_git["gitco"]="git checkout to fzf select"
fn_meta_data_git["gitp"]="git push & set upstream"

# nav
fn_meta_data_nav["cdls"]="navigate to a directory and list it's contents"
fn_meta_data_nav["mkcd"]="create a directory and then navigate to it"

# meta
fn_meta_data_meta["fnls"]="show available custom functions"



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




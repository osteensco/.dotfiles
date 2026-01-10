#!/usr/bin/env bash



# show available custom functions
fnls() {

    declare -A fn_meta_data_git
    declare -A fn_meta_data_help
    declare -A fn_meta_data_nav
    declare -A fn_meta_data_workflow

    # git
    fn_meta_data_git["gitco"]="git checkout to fzf select"
    fn_meta_data_git["gitp"]="git push & set upstream"
    fn_meta_data_git["gitbd"]="git branch delete using fzf multi-select"
    fn_meta_data_git["gitsync"]="git catch up local branch with remote of same name and rebase current branch to it"

    # help
    fn_meta_data_help["fnls"]="show available custom functions"

    # nav
    fn_meta_data_nav["ftls"]="navigate to a directory and list it's contents"
    fn_meta_data_nav["mkft"]="create a directory and then navigate to it"
    fn_meta_data_nav["ftnew"]="create a directory, navigate in, and set to a fastTravelCLI key"

    # workflow
    fn_meta_data_workflow["pytivate"]="activate python virtual environment from list of available in current project"
    fn_meta_data_workflow["sshstart"]="start ssh server"
    fn_meta_data_workflow["sshstop"]="stop ssh server"

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
    
    printf "\nworkflow\n"
    for key val in "${(@kv)fn_meta_data_workflow}"; do
        echo $(showfunc $key $val)
    done

    printf "\nhelp\n"
    for key val in "${(@kv)fn_meta_data_help}"; do
        echo $(showfunc $key $val)
    done

}








#!/bin/bash

# check if modules are install and if not have pip install them.
check_modules()
{
    modules=('random' 'enum' 'textwrap')
    for module in "${modules[@]}"; do
        pip freeze | grep -q "^$module=="
        if [ $? -eq 1 ]; then
            echo "$module is not installed. Installing..."
            pip install $module
        fi
    done
}

usage()
{
    echo "Usage: cowpy-setup.sh -p[--prefix] -s[--zsh] -g[--bash]"
    echo "Options:"
    echo "  -p, --prefix     prefix for cow-py root directory, default is current directory"
    echo "  -s, --zsh       add cow-py to zsh profile"
    echo "  -g, --bash      add cow-py to bash profile"
    echo "  -h, --help      show usage"
    exit 1
}

set_profile()
{
    # set shell profile 
    if [[ -n $zsh ]]; then
        export profile=$ROOT_DIR/.zshrc
    fi

    if [[ -n $bash ]]; then
        export profile=$ROOT_DIR/.bashrc
    fi
    # will default to bash is no profile is specified, will inform user
    if [[ -z $bash ]] && [[ -z $zsh ]]; then
        echo "Error: no shell profile specified"
        echo "Setting profile to bash by default"
        export profile=$ROOT_DIR/.bashrc
    fi
    # will error if both profiles are specified
    if [[ -n $bash ]] && [[ -n $zsh ]]; then
        echo "Error: too many shell profiles specified"
        echo "Please specify only one shell profile"
        echo "--bash OR --zsh"
        exit 1
    fi
}

# check if python is install and on path
check_python()
{
    # check if python is installed
    echo "Checking if python is installed"
    if ! command -v python &> /dev/null; then
        echo "Error: python is not installed"
        echo "Please install python and try again"
        echo "https://www.python.org/downloads/"
        exit 1
    else
        echo "Python is installed"
    fi
    # check if python is on path
    echo "Checking if python is on path"
    if ! command -v python &> /dev/null; then
        echo "PATH=$(which python):$PATH" >> $1
        source $1
    fi 
    if ! command -v python &> /dev/null; then
        echo "Error: python is not on path"
        echo "Please add python to path and try again"
        exit 1
    else
        echo "Python is on path"
    fi
}

export -f check_modules 
export -f usage
export -f set_profile
export -f check_python
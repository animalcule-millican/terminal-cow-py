#!/bin/bash
# Parse command line arguments
TEMP=$(getopt -o pbzh: --long prefix:,bash,zsh,help: \
              -n "$script_name" -- "$@")
# Note the quotes around '$TEMP': they are essential!
eval set -- "$TEMP"
# parse usage arguments
while true; do
  case "$1" in
    -p | --prefix ) name="$2"; shift ;;
    -g | --bash ) bash="ture"; shift ;;
    -s | --zsh ) zsh="true"; shift ;;
    -h | --help ) HELP="$2"; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# check if prefix is set
if [ -z "${name}" ]; then
    echo "Error: prefix not set"
    echo "Adding terminal-cow-py to current directory"
    echo "COW_ROOT=$(pwd)"
else
    export COW_ROOT="$prefix"
fi
# source functions
source $COW_ROOT/lib/install_funcs.sh

# check if help was passed
if [ -z "${HELP}" ]; then
    usage
fi
set_profile
# check if python is installed
check_python $profile
# check if modules are installed
check_modules
# append cowpy_say.py to profile
echo "$COW_ROOT/cowpy_say.py -i $COW_ROOT/data/jokes-for-cows.txt" >> $profile
# inform user of changes
echo "Cowpy [$COW_ROOT/cowpy_say.py] was added to ${profile}."
# cleanup from installation
$COW_ROOT/scripts/cleanup.sh
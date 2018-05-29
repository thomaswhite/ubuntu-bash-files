#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
download_path="$HOME/tmp"
download_deb="$download_path/deb"
build_path="$download_path/buld"

mkdir -p $download_deb
mkdir -p $build_path

pushd $download_path

#declare -F | grep ppa
# if [ -n "$(declare -F git_clone_or_checkout)"  ]; then
wget -N -q https://raw.githubusercontent.com/thomaswhite/ubuntu-bash-files/master/.bash_functions_git
wget -N -q https://raw.githubusercontent.com/thomaswhite/ubuntu-bash-files/master/.bash_functions_ppa-deb
wget -N -q https://raw.githubusercontent.com/thomaswhite/ubuntu-bash-files/master/.bash_functions_print
wget -N -q https://raw.githubusercontent.com/thomaswhite/ubuntu-bash-files/master/.bash_functions_dir
source .bash_functions_git
source .bash_functions_ppa-deb
source .bash_functions_dir
source .bash_functions_print

popd

rulem " $(date +%Y-%m-%d:%H:%M:%S), running file: ${0##*/} "

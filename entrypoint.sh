#!/bin/bash

set -ex
set -o pipefail

function set_mirrors() {
    if [ ! "$INPUT_MIRROR" ]; then
        INPUT_MIRROR="bfsu"
    fi
    if [ -e /tmp/"${INPUT_MIRROR}".condarc ]; then
        cp -f /tmp/"${INPUT_MIRROR}".condarc "${HOME}"/.condarc
        cp -f /tmp/"${INPUT_MIRROR}".sources.list /etc/apt/sources.list
        cp -f /tmp/"${INPUT_MIRROR}".Rprofile "${HOME}"/.Rprofile
    fi
}

function add_channels() {
    if (( ${#INPUT_CHANNELS} != 0 )); then
        for C in ${INPUT_CHANNELS}; do
            conda config --add channels "$C"
        done
    fi

}

function install_packages() {
    if (( ${#INPUT_PACKAGES} != 0 )); then
	    conda update --all -y -q
        conda install -y ${INPUT_PACKAGES[@]}
    fi
}

function run_cmd() {
    if (( ${#INPUT_CMD} != 0)); then
        ${INPUT_CMD}
    fi
}

function main() {
    if (( $# != 0 )); then
        $@
    else
        /bin/bash
    fi
}

set_mirrors
add_channels
install_packages
run_cmd
main $@
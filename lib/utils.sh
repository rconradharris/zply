#!/bin/bash

VERSION=0.1

function version() {
    echo $VERSION
    exit 0
}

function die() {
    >&2 echo "[$CMD error]: $@"
    exit 1
}

function realpath {
    echo $(cd $(dirname $1); pwd)/$(basename $1);
}

function check_patch_repo() {
    if [[ ! -e $1 ]]; then
        die "Patch repo directory not found"
    elif [[ ! -e $1/.git ]]; then
        die "Patch repo is not a git repo (did you git init it?)"
    fi
}

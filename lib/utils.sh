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

function parse_std_opts() {
    while getopts 'hv' opt; do
        case $opt in
            h) usage;;
            v) version;;
            *) usage;;
        esac
    done
    shift $(($OPTIND - 1))
}

function verify_two_args() {
    if [[ -z $1 ]] || [[ -z $2 ]]; then
        usage
    fi
}

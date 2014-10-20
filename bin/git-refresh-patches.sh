CMD='git refresh-patches'
FORMAT_PATH=$PWD/.patches

function cleanup() {
    if [[ -e $FORMAT_PATH ]]; then
        rm -rf $FORMAT_PATH
    fi
}

function die_with_cleanup() {
    cleanup
    die $@
}

function usage() {
    >&2 echo $@ "usage: $CMD [-h] [-v] <patch-repo-dir> <since>"
    exit 1
}

while getopts 'hv' opt; do
    case $opt in
        h) usage;;
        v) version;;
        *) usage;;
    esac
done

shift $(($OPTIND - 1))

if [[ -z $1 ]] || [[ -z $2 ]]; then
    usage
fi

PATCH_REPO_PATH=$1
SINCE=$2

check_patch_repo $PATCH_REPO_PATH
git zply-format -o $FORMAT_PATH $SINCE || die_with_cleanup "git zply-format failed"
git zply-sync $FORMAT_PATH $PATCH_REPO_PATH || die_with_cleanup "git zply-sync failed"
cleanup

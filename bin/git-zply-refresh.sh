# NAME
#
#   git-save-patch - save patch series to patch repo
#
# SYNOPSIS
#
#   git-save-patch <patch-repo-path> <since>
#
# DESCRIPTION
#
#   Creates a series of patches and saves them into the patch repo.
#
# OUTPUT
#
#   Prints current step to stdout
#
# EXIT STATUS
#
#   0 - success
#   1 - failure
CMD='git zply-refresh'
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
    >&2 echo $@ "usage: $CMD [-h] [-v] <patch-repo-path> <since>"
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
check_patch_repo $PATCH_REPO_PATH
SINCE=$2
git rev-parse -q --verify $SINCE > /dev/null || die "Revision $SINCE not found"
BASED_ON_HASH=`git rev-parse $SINCE`

git zply-format -o $FORMAT_PATH $SINCE || die_with_cleanup "git zply-format failed"
git zply-sync $FORMAT_PATH $PATCH_REPO_PATH || die_with_cleanup "git zply-sync failed"
git zply-commit -b $BASED_ON_HASH $PATCH_REPO_PATH || die_with_cleanup "git zply-commit failed"

cleanup

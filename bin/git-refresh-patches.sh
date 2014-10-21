CMD='git refresh-patches'

function usage() {
    >&2 echo $@ "usage: $CMD [-h] [-v] <patch-repo-dir> <since>"
    exit 1
}

parse_std_opts
verify_two_args

PATCH_REPO_DIR=$1
SINCE=$2
FORMAT_PATH=$PWD/.patches

check_patch_repo $PATCH_REPO_DIR

git zply-format $FORMAT_PATH $SINCE || die "git zply-format failed"

git zply-sync $FORMAT_PATH $PATCH_REPO_DIR
if [[ $? -eq 0 ]]; then
    echo "No changes to patch repo"
    exit 0
elif [[ $? -eq 1 ]]; then
    die "git zply-sync failed"
fi

rm -rf $FORMAT_PATH

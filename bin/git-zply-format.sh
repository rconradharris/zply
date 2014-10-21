CMD='git zply-format'

function usage() {
    >&2 echo $@ "usage: $CMD [-h] [-v] <patches-dir> <since>"
    exit 1
}

parse_std_opts
verify_two_args

PATCHES_DIR=$1
SINCE=$2

# Convert `since` to a commit hash
git rev-parse -q --verify $SINCE > /dev/null || die "Revision $SINCE not found"
SINCE=`git rev-parse $SINCE`

if [[ -e .git/rebase-apply ]]; then
    die "Cannot format patches while a rebase is in progress (in the middle of git am?)"
fi

git format-patch -kpo $PATCHES_DIR $SINCE > /dev/null || die "git format-patch failed"

# Make sure we generated at least one patch file
ls $PATCHES_DIR/*.patch 2>&1 > /dev/null
if [[ $? -ne 0 ]]; then
    die "No patch files generated (did you forget to run git am?)"
fi

for patch in `ls $PATCHES_DIR/*.patch`; do
    git zply-fixup $patch > $patch.tmp || die "git zply-fixup failed"
    mv $patch.tmp $patch
done

echo $SINCE > $PATCHES_DIR/.based-on

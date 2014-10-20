CMD='git zply-format'

function usage() {
    >&2 echo $@ "usage: $CMD [-h] [-o output-path] [-v] <since>"
    exit 1
}

OUTPUT_PATH=.

while getopts 'ho:v' opt; do
    case $opt in
        h) usage;;
        o) OUTPUT_PATH=$OPTARG;;
        v) version;;
        *) usage;;
    esac
done
shift $(($OPTIND - 1))

if [[ -z $1 ]]; then
    usage
fi

SINCE=$1

# Convert `since` to a commit hash
git rev-parse -q --verify $SINCE > /dev/null || die "Revision $SINCE not found"
SINCE=`git rev-parse $SINCE`

if [[ -e .git/rebase-apply ]]; then
    die "Cannot format patches while a rebase is in progress (in the middle of git am?)"
fi

echo "Formatting patches..."
git format-patch -kpo $OUTPUT_PATH $SINCE > /dev/null || die "git format-patch failed"

# Make sure we generated at least one patch file
ls $OUTPUT_PATH/*.patch 2>&1 > /dev/null
if [[ $? -ne 0 ]]; then
    die "No patch files generated (did you forget to run git am?)"
fi

for patch in `ls $OUTPUT_PATH/*.patch`; do
    git zply-fixup $patch > $patch.tmp || die "git zply-fixup failed"
    mv $patch.tmp $patch
done

echo $SINCE > $OUTPUT_PATH/.based-on

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

echo "Formatting patches..."
git format-patch -kpo $OUTPUT_PATH $SINCE > /dev/null || die "git format-patch failed"

for patch in `ls $OUTPUT_PATH/*.patch`; do
    git zply-fixup $patch > $patch.tmp || die "git zply-fixup failed"
    mv $patch.tmp $patch
done

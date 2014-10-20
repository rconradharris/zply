CMD='git zply-commit'

function cleanup() {
if [[ -e .tmp-commit-msg ]]; then
    rm .tmp-commit-msg
fi
}

function die_with_cleanup() {
    cleanup
    die $@
}

function usage() {
    >&2 echo $@ "usage: $CMD [-b based-on] [-h] [-v] <patch-repo-dir>"
    exit 1
}

while getopts 'b:hv' opt; do
    case $opt in
        b) BASED_ON=$OPTARG;;
        h) usage;;
        v) version;;
        *) usage;;
    esac
done

shift $(($OPTIND - 1))

if [[ -z $1 ]]; then
    usage
fi

PATCH_REPO_PATH=`realpath $1`
check_patch_repo $PATCH_REPO_PATH

pushd $PATCH_REPO_PATH > /dev/null

git add -A *.patch || die "git add -A failed"

if [[ -e .gitmessage.txt ]]; then
    cp .gitmessage.txt .tmp-commit-msg
    TEMPLATE=1
else
    cat > .tmp-commit-msg <<-EOF
Refreshing patches...
EOF
    TEMPLATE=0
fi

# Add based-on annotation
if [[ -n $BASED_ON ]]; then
    echo >> .tmp-commit-msg
    echo "Based-On: $BASED_ON" >> .tmp-commit-msg
fi

if [[ $TEMPLATE -eq 1 ]]; then
    # -t means that the commit message must be edited or the commit is aborted
    git commit -qt .tmp-commit-msg
else
    # -eF means don't require commit message be edited
    git commit -qeF .tmp-commit-msg
fi

if [[ $? -ne 0 ]]; then
    die_with_cleanup "git commit failed"
fi

cleanup
echo "Commited patches"
popd > /dev/null

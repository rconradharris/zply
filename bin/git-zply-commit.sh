CMD='git zply-commit'

function usage() {
    >&2 echo $@ "usage: $CMD [-b based-on] [-h] [-v] <patch-repo-path>"
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
cat > .tmp-commit-msg <<-EOF
Saving patches...
EOF

# Add based-on annotation
if [[ -n $BASED_ON ]]; then
    echo >> .tmp-commit-msg
    echo "Based-On: $BASED_ON" >> .tmp-commit-msg
fi

# -t would abort the commit if the message was not edited; we don't want to
# require that in all cases, so using -eF instead
git commit -qeF .tmp-commit-msg
rm .tmp-commit-msg
echo "Commited patches"
popd > /dev/null

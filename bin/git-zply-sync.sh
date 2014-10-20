CMD='git zply-sync'

function usage() {
    >&2 echo $@ "usage: $CMD [-h] [-v] <patches-dir> <patch-repo-dir>"
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

FORMAT_PATH=`realpath $1`
PATCH_REPO_PATH=`realpath $2`
check_patch_repo $PATCH_REPO_PATH

# Copy patches into patch repo
for patch in `ls $FORMAT_PATH/*.patch`; do
    # Only copy patches that meaningfully changed
    copy_patch=1
    patch_basename=`basename $patch`
    repo_patch=$PATCH_REPO_PATH/$patch_basename
    if [[ -e $repo_patch ]]; then
        git zply-diff $patch $repo_patch > /dev/null
        if [[ $? -eq 0 ]]; then
            copy_patch=0
        elif [[ $? -ne 1 ]]; then
            die "git zply-diff failed"
        fi
    fi

    if [[ $copy_patch -eq 1 ]]; then
        echo "Copying $patch_basename"
        cp $patch $PATCH_REPO_PATH || die "cp failed: $patch_basename"
    fi
done

cp $FORMAT_PATH/.based-on $PATCH_REPO_PATH

# git add new/updated patches; git rm unused patches
pushd $PATCH_REPO_PATH > /dev/null

for patch in `ls *.patch`; do
    patch_basename=`basename $patch`
    if [[ -e $FORMAT_PATH/$patch_basename ]]; then
        git add $patch_basename || die "git add failed for $patch_basename"
    else
        echo "Removing unused patch $patch_basename"
        git rm $patch_basename || die "git rm failed for $patch_basename"
    fi
done

git add .based-on

popd > /dev/null

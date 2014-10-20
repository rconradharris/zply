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

pushd $PATCH_REPO_PATH > /dev/null

for patch in `ls *.patch`; do
    patch_basename=`basename $patch`
    if [[ ! -e $FORMAT_PATH/$patch_basename ]]; then
        echo "Removing unused patch $patch_basename"
        rm $patch_basename || die "rm failed: $patch_basename"
    fi
done

popd > /dev/null

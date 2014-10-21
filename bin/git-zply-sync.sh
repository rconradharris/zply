CMD='git zply-sync'
RET=0

function usage() {
    >&2 echo $@ "usage: $CMD [-h] [-v] <patches-dir> <patch-repo-dir>"
    exit 1
}

parse_std_opts
verify_two_args

PATCHES_DIR=`realpath $1`
PATCH_REPO_DIR=`realpath $2`
check_patch_repo $PATCH_REPO_DIR

# Copy patches into patch repo
for patch in `ls $PATCHES_DIR/*.patch`; do
    # Only copy patches that meaningfully changed
    copy_patch=1
    patch_basename=`basename $patch`
    repo_patch=$PATCH_REPO_DIR/$patch_basename
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
        cp $patch $PATCH_REPO_DIR || die "cp failed: $patch_basename"
        RET=2
    fi
done

# git add new/updated patches; git rm unused patches
pushd $PATCH_REPO_DIR > /dev/null

for patch in `ls *.patch`; do
    patch_basename=`basename $patch`
    if [[ -e $PATCHES_DIR/$patch_basename ]]; then
        git add $patch_basename || die "git add failed for $patch_basename"
    else
        echo "Removing unused patch $patch_basename"
        git rm $patch_basename || die "git rm failed for $patch_basename"
        RET=2
    fi
done

copy_based_on=1
if [[ -e .based-on ]]; then
    diff $PATCHES_DIR/.based-on .based-on > /dev/null
    if [[ $? -eq 0 ]]; then
        copy_based_on=0
    fi
fi

if [[ $copy_based_on -eq 1 ]]; then
    cp $PATCHES_DIR/.based-on $PATCH_REPO_DIR
    git add .based-on
    RET=2
fi

popd > /dev/null

exit $RET

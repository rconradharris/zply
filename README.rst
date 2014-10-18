=============================================
zply - zero-ply: minimal git patch management
=============================================


Save Patches to Patch Repo
==========================

Run zply's `save-patch` command::

    git save-patch /path/to/patch-repo <since>

This command does the following:

    * Runs `git format-patch` to generate the patch series
    * Runs `fixup-patch` to remove extraneous information from patch files
      (improves diffing of patch files by reducing unecessary changes)
    * Runs `diff-patch` to determine if the patch changed in a 'meaningful'
      way (hash changes only are not considered meaningful)
    * Copies the patches that meaningfully changed into the patch-repo
    * Commits the patches using git


Apply Patches
=============

Just use git::

    git am /path/to/patch-repo/*.patch


Modify Patches
==============

Just use git::

    git rebase -i <since>


Workflow: Initial Setup
=======================

1. Setup patch repo::

    mkdir /path/to/patch-repo
    cd /path/to/patch-repo
    git init .


Workflow: Add New Patch
=======================


1. Apply patches::

    git am /path/to/patch-repo/*.patch

2. Create a new commit::

    # Edit files
    git commit -m "New commit"

3. Save the new patch::

    git save-patch /path/to/patch-repo HEAD^


Workflow: Edit/Rename/Remove/Reorder Existing Patches
=====================================================

1. Apply patches::

    git am /path/to/patch-repo/*.patch

2. Use interactive rebase to make any changes::

    git rebase -i <since>

3. Save the new patch::

    git save-patch /path/to/patch-repo <since>

`<since>` refers to the last upstream commit. For example if you have a
branch `master` that tracks upstream you could use the string `master`.
Altneratively, you can use a specific commit hash.

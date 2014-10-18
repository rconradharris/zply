Why zply instead of ply?
========================

* Radically simpler code
* Small, composable commands
* Less duplication of existing git functionality
    * No restore command: just ``git am --3way``
    * No rollback command: just ``git reset --hard``
    * No resolve/skip/abort commands, use: ``git am --continue``, ``git am --skip``, ``git am --abort``
* No extra series file to maintain (less to get out of sync)
* No linking or unlinking repos
* Only one additional user-facing git command ``git save-patch``
* ``zply`` is not needed to apply patches (jenkins no longer needs to have
  ```ply`` installed) -- only patch maintainers who are modifying patches need
  ``zply``


Downsides
=========

* Need to convert patch-repos to new format
* Requires modifying jenkins tooling to use it (should actually be easy)
* Installation of commands might be slightly trickier
* Requires more understanding of git; users are expected to know how to apply
  patches
* Rollback can be slightly trickier until you get used to it
* Reordering patches causes more files to be touched

History
=======

``zply`` is the third-iteration of a patch-management workflow built entirely
around just ``git``.

ply-initial: simple but incomplete (never used in production)
ply: complete but complex and somewhat buggy for edge cases
zply: simple and complete


What It Needs to Do and Why?
============================

* Create patch files

* Copy patch files into patch repo (but only copy files that meaningfully
  changed, a naive copy will result in extremely chatty diffs in the
  patch-repo making changes hard to review)

* Remove any deleted patches from patch repo

* Commit modified patches into patch repo


Commands
========

zply-save
    zply-format
    zply-sync
    zply-commit -b $BASED_ON

zply-format
    git format-patch
    zply-fixup

zply-sync
    zply-diff

zply-commit -b [based-on]
    git add
    git commit

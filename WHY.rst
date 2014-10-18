Why zply instead of ply?
========================

* Radically simpler code
* Less duplication of existing git functionality
    * No restore command: just ``git am --3way``
    * No rollback command: just ``git reset --hard``
    * No resolve/skip/abort commands, use: ``git am --continue``, ``git am --skip``, ``git am --abort``
* No extra series file to maintain (less to get out of sync)
* No linking or unlinking repos
* Only one additional user-facing git command ``git save-patch``

Downsides
=========

* Need to convert patch-repos to new format
* Requires modifying jenkins tooling to use it (should actually be easy)
* Installation of commands might be slightly trickier
* Requires more understanding of git; users are expected to know how to apply
  patches
* Rollback can be slightly trickier until you get used to it

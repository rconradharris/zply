What?
====

``zply`` is an attempt to simplify the ``ply`` patch management tool down to
only the components that add value, namely:

* Automating the process of syncing patches into the patch repo (done by
  hand this is tedious and error prone)

* Recording commit-hash that a patch series was based on so can have enough
  information to reconstruct the code at any point.

* Reducing diff noise: naievely copying all modified patches into the
  patch repo makes review difficult because many of those patches didn't
  change in a meaningful/impactful way (for example, perhaps only
  context-lines or ``index`` hashes changed.)  ``zply`` 'fixes up` patch files
  and uses a smart diffing algorithm to reduce the noise, making code review
  easier.


Things that ``ply`` did that did not add value were:

* Apply patches (``git am`` can do this)

* Rollback patches (``git reset --hard`` can do this)

* Initialize patch repo (simple to do by hand with just ``git``)

* Link working repo to patch repo (unecessary if commands take
  ``patch-repo-dir`` as argument)

* Apply status (``git log`` can do this)

* Patch repo health check (unecessary if no ``series`` file)

* DOT graphs of patch dependencies (cool but not used, should be a
  separate tool anyway)

* Automatically commiting into the patch repo; users should commit manually
  after reviewing the diff


Why zply instead of ply?
========================

* Radically simpler code
* Small, composable commands
* All commands get a man page (no external documentation needed)
* Less duplication of existing git functionality
    * No restore command: just ``git am --3way``
    * No rollback command: just ``git reset --hard``
    * No resolve/skip/abort commands, use: ``git am --continue``, ``git am --skip``, ``git am --abort``
* No extra series file to maintain (less to get out of sync)
* No linking or unlinking repos
* Only one additional user-facing git command ``git refresh-patches``
* ``zply`` is not needed to apply patches (jenkins no longer needs to have
  ```ply`` installed) -- only patch maintainers who are modifying patches need
  ``zply``
* Use standard terminology ('refresh' patches, inline with ``quilt`` and
  ``stgit``)
* More deterministic (no guessing last upstream hash, you specify it!)


Downsides
=========

* Need to convert patch-repos to new format
* Requires modifying Jenkins (Jenkins no longer needs ``ply`` or ``zply`` at
  all, just `git am``)
* Installation of commands slightly trickier, instead of ``pip install ply``,
  you ``git clone`` and then run ``make``
* Requires more understanding of ``git``; users are expected to know how to apply
  patches, and what a 3-way merge is.
* Rollback can be slightly trickier until you get used to it
* Reordering patches causes more files to be touched (since patch-number is
  embdedded in filename)
* ``zply`` does not fix the missing-blob issue. That is just an inherent
  problem with using a 3way merge based on patch files. It's an annoyance, but
  not a show-stopper.


History
=======

``zply`` is the third-iteration of a patch-management workflow built entirely
around just ``git-rebase``.

* ply-initial: simple but incomplete (never used in production)
* ply: complete but complex and somewhat buggy for edge cases
* zply: simple and complete


What It Needs to Do and Why?
============================

* Create patch files

* Copy patch files into patch repo (but only copy files that meaningfully
  changed, a naive copy will result in extremely chatty diffs in the
  patch-repo making changes hard to review)

* Remove any deleted patches from patch repo

* Commit modified patches into patch repo


Commands (Porcelain)
====================

* git refresh-patches


Commands (Plumbing)
===================

* git zply-diff
* git zply-fixup
* git zply-format
* git zply-sync

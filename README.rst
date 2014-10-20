======================================
zero-ply: minimal git patch management
======================================

Description
===========

``zply`` is an extremely simple way to manage patches using ``git``.

``zply`` comes about from the observation that managing patches as **commits**
on a separate branch and using ``git rebase`` to update them is a very
convenient workflow. The problem, however, is since ``git rebase`` rewrites the
history, there's a risk of losing work. 

The goal of ``zply`` is to allow this ``git rebase`` workflow in such a way
that makes it safe. It achieves this by storing patches as **files** in a
separate git repository, the **patch repo**, instead of **commits** on a
**branch**.

Only a single new user-facing command is added ``git refresh-patches`` which saves
a patch series into the patch repo.

Tasks
=====

Apply Patches
-------------

::

    git am --3way /path/to/patch-repo/*.patch


Modify Patches
--------------

::

    git rebase -i HEAD~10


Refresh Patches
---------------

::

    git refresh-patches /path/to/patch-repo HEAD~10


Rollback Patches
----------------

::

    git reset --hard HEAD~10


Setup Patch Repo
----------------

::

    mkdir /path/to/patch-repo
    cd /path/to/patch-repo
    git init .


Workflows
==========

Add New Patch
-------------

1. Apply patches::

    git am /path/to/patch-repo/*.patch

2. Create a new commit::

    # Edit files
    git commit -m "New commit"

3. Save the new patch::

    git save-patch /path/to/patch-repo HEAD^


Workflow: Edit/delete existing patch
====================================

1. Apply patches::

    git am --3way /path/to/patch-repo/*.patch

2. Use interactive rebase edit/delete patch::

    git rebase -i HEAD~10

3. Refresh patches in patch repo::

    git refresh-patches /path/to/patch-repo HEAD~10

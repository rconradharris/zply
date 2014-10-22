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

Tasks
=====

Apply Patches
-------------

::

    git apply-patches

    # Plain git am also works
    git am --3way /path/to/patch-repo/*.patch


Modify Patches
--------------

::

    git rebase -i HEAD~10


Refresh Patches
---------------

::

    git refresh-patches


Commit Patches
--------------

::

    git commit-patches


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

    git apply-patches

2. Create a new commit::

    # Edit files
    git commit -m "New commit"

3. Save the new patch::

    git refresh-patches HEAD^


Workflow: Edit/delete existing patch
====================================

1. Apply patches::

    git apply-patches

2. Use interactive rebase edit/delete patch::

    git rebase -i HEAD~10

3. Refresh patches in patch repo::

    git refresh-patches HEAD~10


Configuration
=============

The working repo can contain a configuration file at ``.git/zply``. Checkout
``etc/zply.sample`` for an exmaple config.

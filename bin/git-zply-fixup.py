#!/usr/bin/env python
import os
import sys

CMD = 'git zply-fixup'
VERSION = '0.1'


def _remove_trailing_extra_blank_lines_from_subject(lines):
    """Different versions of git will output different amounts of trailing
    whitespace at the end of a subject headers, so we normalize it by only
    allowing a single trailing blank line.
    """
    for idx, line in enumerate(lines):
        if line.startswith('diff --git'):
            break
    else:
        return

    if idx < 2:
        return

    # If we have two blanks above first `diff --git` remove one of them
    if not lines[idx - 1].strip() and not lines[idx - 2].strip():
        del lines[idx - 1]


def _fixup(lines):
    # Delete From <hash> <magic-date> line
    del lines[0]

    # Delete git version
    del lines[-1]
    del lines[-1]
    del lines[-1]
    del lines[-1]

    _remove_trailing_extra_blank_lines_from_subject(lines)


def usage():
    print >> sys.stderr, "usage: %s [-h] [-v] <patch-file>" % CMD
    sys.exit(2)


def version():
    print VERSION
    sys.exit(0)


def die(msg, code=1):
    print >> sys.stderr, "[%s error]: %s" % (CMD, msg)
    sys.exit(code)


if __name__ == '__main__':
    if '-h' in sys.argv:
        usage()
    elif '-v' in sys.argv:
        version()
    elif len(sys.argv) < 2:
        usage()

    filename = sys.argv[1]

    if not os.path.exists(filename):
        die("file '%s' not found" % filename, code=3)

    with open(filename) as f:
        patch = f.read()

    lines = patch.split('\n')
    _fixup(lines)
    print '\n'.join(lines)

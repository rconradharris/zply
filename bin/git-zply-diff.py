#!/usr/bin/env python
import os
import subprocess
import sys

CMD = 'git zply-diff'
VERSION = '0.1'


def meaningful_diff(source_path, dest_path):
    """Determines whether a patch changed in a 'meaningful' way.

    The purpose here is to avoid chatty-diffs generated by `ply save` where
    the only changes to a patch-file are around context and index hash
    changes.

    `diff_output` is used for testing and makes `source_path` and `dest_path`
    non-applicable fields.
    """
    proc = subprocess.Popen(['diff', '-U', '0', source_path, dest_path],
                            stdout=subprocess.PIPE)
    diff_output = proc.communicate()[0]

    if proc.returncode == 0:
        return False
    elif proc.returncode != 1:
        raise Exception('Unknown returncode from diff: %s'
                        % proc.returncode)

    last_index_line = None
    lines = diff_output.split('\n')
    result = False

    for line in lines:
        line = line.strip()

        if not line:
            continue
        elif line.startswith('@@'):
            pass
        elif line.startswith('-@@') or line.startswith('+@@'):
            pass
        elif line.startswith('---') or line.startswith('+++'):
            pass
        elif line.startswith('-index'):
            last_index_line = line
        elif line.startswith('+index') and not last_index_line:
            result = True
            print line
        elif line.startswith('+index') and last_index_line:
            try:
                last_perms = last_index_line.split()[2]
            except IndexError:
                last_perms = None

            try:
                perms = line.split()[2]
            except IndexError:
                perms = None

            if perms != last_perms:
                print last_index_line
                print line
                result = True

            last_index_line = None
        else:
            print line
            result = True

    return result


def usage():
    print >> sys.stderr, "usage: %s [-h] [-v]"\
                         " <patch-file1> <patch-file2>" % CMD
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
    elif len(sys.argv) < 3:
        usage()

    filename1 = sys.argv[1]
    filename2 = sys.argv[2]

    for filename in (filename1, filename2):
        if not os.path.exists(filename):
            die("file '%s' not found" % filename, code=3)

    differs = meaningful_diff(filename1, filename2)
    exit_code = 1 if differs else 0
    sys.exit(exit_code)

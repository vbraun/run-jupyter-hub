#!/usr/bin/env python

import sys
import os
import subprocess
import shutil
import stat


def set_capabilities(filename):
    print('- calling setcap')
    subprocess.check_call([
        'setcap', 'CAP_NET_BIND_SERVICE=+eip', filename
    ])


def copy(source, target):
    print('- copying {0} -> {1}'.format(source, target))
    stat = os.stat(target)
    os.remove(target)
    shutil.copy2(source, target)
    os.chown(target, stat.st_uid, stat.st_gid)
    
    
def un_hashdist_link(filename):
    """
    Replace hashdist launcher and link files with a copy of the original
    """
    link = '{0}.link'.format(filename)
    if not os.path.exists(link):
        return
    with open(link, 'r') as f:
        target = f.read()
    target = os.path.abspath(os.path.join(os.path.dirname(filename), target))
    copy(target, filename)
    os.remove(link)


def un_hashdist(filename):
    """
    Replace hashdist symlinks with a copy of the orginal
    """
    if os.path.islink(filename):
        target = os.readlink(filename)
        if os.path.isabs(target):
            copy(target, filename)

            
def is_executable(filename):
    return bool(stat.S_IXUSR & os.stat(filename)[stat.ST_MODE])
    
    
if __name__ == '__main__':
    for filename in sys.argv[1:]:
        filename = os.path.abspath(filename)
        if filename.endswith('.link'):
            print('Ignoring link file: {0}'.format(filename))
            continue
        print('Setting capabilities on {0}'.format(filename))
        un_hashdist_link(filename)
        un_hashdist(filename)
        if is_executable(filename) and not os.path.islink(filename):
            set_capabilities(filename)


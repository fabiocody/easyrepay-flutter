#!/usr/bin/env python3

from sys import argv
from subprocess import run

FILENAME = 'pubspec.yaml'
BACKUP_FILENAME = '.pubspec.old.yaml'

try:
    with open(FILENAME) as f:
        lines = f.readlines()
except FileNotFoundError:
    print('No pubspec.yaml file in current directory')
    exit(1)

with open(BACKUP_FILENAME, 'w') as f:
    f.writelines(lines)

for i in range(len(lines)):
    if lines[i].startswith('version'):
        split = lines[i].split('+')
        build_number = int(split[1]) + 1
        lines[i] = split[0] + '+' + str(build_number) + '\n'
        break

with open(FILENAME, 'w') as f:
    f.writelines(lines)

if len(argv) > 1 and argv[1] in ['--debug', '--release', '--profile']:
    args = ' ' + argv[1]
else:
    args = ''
run(('flutter build ios' + args).split(), check=False)

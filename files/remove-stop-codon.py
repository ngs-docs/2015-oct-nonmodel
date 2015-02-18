#! /usr/bin/env python
import sys
for line in open(sys.argv[1]):
    line = line.rstrip()
    if line.endswith('*'):
       print line[:-1]
    else:
       print line

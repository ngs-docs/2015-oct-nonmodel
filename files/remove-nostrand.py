#! /usr/bin/env python
import sys
for line in open(sys.argv[1]):
    try:
        x = line.split('\t')
        if x[6] == '.':
            continue
    except:
        pass

    sys.stdout.write(line)


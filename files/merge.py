import sys

infile = sys.argv[1]

data = {}
with open(infile) as fp:
    fp.readline()
    for line in fp:
        bundle, _, count = line.partition(',')
        bundle = int(bundle.strip())
        count = float(count.strip())
        data[bundle] = data.get(bundle, 0) + count
outfile = infile + '.merged'

for key, val in data.iteritems():
    print 'bundle_{k}\t{v}'.format(k=key, v=val)

#! /usr/bin/env python
import sys
import csv
import argparse

# load the gene id, gene name, and nearest reference information from the
# GTF file into two Python dictionaries

def load_gtf_info(filename):
    d = {}
    e = {}
    for line in open(filename):
        info = line.split('\t')[8]
        records = [x.strip() for x in info.split(';')]

        gene_id = None
        gene_name = None
        nearest_ref = None
        for r in records:
            if r.startswith('gene_id'):
                gene_id = r[9:-1]
            elif r.startswith('gene_name'):
                gene_name = r[11:-1]
            elif r.startswith('nearest_ref'):
                nearest_ref = r[13:-1]

        if gene_name and gene_id:
            d[gene_id] = gene_name
        if nearest_ref and gene_id:
            e[gene_id] = nearest_ref

    return d, e

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('gtf')
    parser.add_argument('csv')
    parser.add_argument('cutoff', nargs='?', type=float)
    args = parser.parse_args()

    # load the GTF file
    id_to_name, id_to_nearref = load_gtf_info(args.gtf)

    # for every row in the input CSV, insert gene name and nearest reference
    # into columns 2 and 3.
    w = csv.writer(sys.stdout)
    for row in csv.reader(open(args.csv)):
        if args.cutoff:
            try:
                fdr = float(row[4])
                if fdr > args.cutoff:
                    continue
            except ValueError:
                pass

        gene_id = row[0]
        gene_name = id_to_name.get(gene_id, '')
        row.insert(1, gene_name)
        nearref = id_to_nearref.get(gene_id, '')
        row.insert(2, nearref)
        w.writerow(row)

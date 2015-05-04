BLASTing your assembled data
============================

First, install a few prerequisites::

   
   sudo apt-get -y install lighttpd blast2 git-core

Next, grab things needed for the BLAST server::

   sudo pip install pygr whoosh Pillow Jinja2 \
       git+https://github.com/ctb/pygr-draw.git screed
   sudo ln -s /usr/bin/blastall /usr/local/bin/

Install the BLAST server and configure it::

   cd
   git clone https://github.com/ctb/blastkit.git -b 2015-may-nonmodel
   sudo ./blastkit/configure-lighttpd.sh

   cd blastkit/www
   sudo ln -fs $PWD /var/www/blastkit

   mkdir files
   chmod a+rxwt files
   chmod +x /home/ubuntu

   cd /home/ubuntu/blastkit
   python ./check.py

Now, copy in your newly created transcriptome::

   cd /mnt/work
   gunzip -c trinity-nematostella-raw.renamed.fasta.gz > /home/ubuntu/blastkit/db/db.fa

   cd /home/ubuntu/blastkit
   formatdb -i db/db.fa -o T -p F
   python index-db.py db/db.fa

You can now access your BLAST server at http://<amazon machine
name>/blastkit/.  Note that you will need to enable HTTP access on
your Amazon firewall settings.

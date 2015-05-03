BLASTing your assembled data
============================

::

   apt-get -y install lighttpd blast2
   pip install pygr whoosh Pillow Jinja2 \
       git+https://github.com/ctb/pygr-draw.git screed
   ln -s /usr/bin/blastall /usr/local/bin/


   cd /etc/lighttpd/conf-enabled
   ln -fs ../conf-available/10-cgi.conf ./
   echo 'cgi.assign = ( ".cgi" => "" )' >> 10-cgi.conf
   echo 'index-file.names += ( "index.cgi" ) ' >> 10-cgi.conf

   /etc/init.d/lighttpd restart

   cd
   git clone https://github.com/ctb/blastkit.git -b ec2
   cd blastkit/www
   ln -fs $PWD /var/www/blastkit

   mkdir files
   chmod a+rxwt files
   chmod +x /home/ubuntu


   cd /home/ubuntu/blastkit
   python ./check.py

   cd /mnt/work
   gunzip -c trinity-nematostella-raw.renamed.fasta.gz > /home/ubuntu/blastkit/db/db.fa

   cd /home/ubuntu/blastkit
   formatdb -i db/db.fa -o T -p F
   python index-db.py db/db.fa

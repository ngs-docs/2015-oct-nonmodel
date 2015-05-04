===============================
Getting started with Amazon EC2
===============================

Short version:

* go to http://aws.amazon.com/, log in, then "EC2" (upper left);
* select "Launch instance";
* select "Ubuntu 14.04" from the list;
* select "m3.xlarge" from the list (towards bottom of "General purpose");
* click "Review and launch"
* select "Launch";
* if your first time through, create a key pair; otherwise select existing;
* click "launch instance"

More details:
~~~~~~~~~~~~~

.. toctree::
   :maxdepth: 2

   start-up-an-ec2-instance
   log-in-with-ssh-win
   log-in-with-ssh-mac

   ...installing-dropbox

A final checklist:

- EC2 instance is running;
- used ubuntu 14.04
- NOT a micro instance (m3.xlarge, or bigger);

.. - SSH, HTTP, HTTPS are enabled on the security group;

Amazon Web Services reference material
--------------------------------------

`Instance types <http://aws.amazon.com/ec2/instance-types/>`__

`Instance costs <http://aws.amazon.com/ec2/pricing/>`__

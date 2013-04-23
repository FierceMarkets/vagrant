vagrant
=======

Some vagrant and puppet files.

drupal7-centos
--------------

This contains a CentOS 6 setup with LAMP stuff and a structure for drupal.  The DB name is drupal and it uses the root and empty password login that mysql defaults to.  Put drupal in the drupal directory, make sure drupal/sites/default/files exists, and start then vagrant up.  Set up vagrant.local in your hosts file to point to 192.168.33.10.  Then visit http://vagrant.local/install.php to kick off the install process.

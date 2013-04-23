class updates {

  exec { 'yum upgrade':
    command => '/usr/bin/yum upgrade -y',
    before => Package['php'],
  }
}

class php {

  package {'php':
    ensure => present,
    before => File['/etc/php.ini'],
  }

  package { "php-cli":
    ensure  => present,
  }

  package { "php-common":
    ensure  => present,
  }

  package { "php-devel":
    ensure  => present,
  }

  package { "php-pear":
    ensure  => present,
  }

  package { "php-pdo":
    ensure  => present,
  }

  package { "php-mysql":
    ensure  => present,
  }

  package { "php-gd":
    ensure  => present,
  }

#  package { "php-mcrypt":
#    ensure  => present,
#  }

  package { "php-intl":
    ensure  => present,
  }

  package { "php-mbstring":
    ensure  => present,
  }

  package { "php-pecl-apc":
    ensure  => present,
  }

  package { "php-xml":
    ensure  => present,
  }

  file {'/etc/php.ini':
    ensure => file,
  }
}

class pear {
  exec {'pear upgrade PEAR':
    command => '/usr/bin/pear upgrade PEAR',
    require => Package['php-pear']
  }

  exec {'pear channel update':
    command => '/usr/bin/pear channel-update pear.php.net',
    require => Package['php-pear']
  }

  exec {'pear upgrade':
    command => '/usr/bin/pear upgrade',
    require => Exec['pear upgrade PEAR']
  }

  # exec {'install xhprof':
  #   command => '/usr/bin/pecl install xhprof-0.9.2',
  #   require => Exec['pear upgrade PEAR']
  # }
}

class drush {
  exec {'drush discover':
    command => '/usr/bin/pear channel-discover pear.drush.org',
    require => Package['php-pear']
  }

  exec {'install drush':
    command => '/usr/bin/pear install drush/drush',
    require => Exec['drush discover']
  }

  exec {'install drush dependencies':
    command => '/usr/bin/drush',
    require => Exec['install drush']
  }
}

class httpd {

  file {'/var/www/html':
    ensure => link,
    target => "/vagrant/drupal",
    force  => true,
    require => Package['httpd']
  }

  # file {'/var/www/drupal-files':
  #   ensure => directory,
  #   group => 'apache',
  #   owner => 'apache',
  #   mode => '0777',
  #   require => File['/var/www/html']
  # }

  # file {'/var/www/html/sites/default/files':
  #   ensure => link,
  #   target => '/var/www/drupal-files',
  #   require => File['/var/www/drupal-files'],
  #   force => true,
  # }

  package {'httpd':
    ensure => present,
  }

  package { "httpd-devel":
    ensure  => present
  }

  service {'httpd':
    ensure => running,
    enable => true,
    require => Package['httpd'],
    subscribe => File['/etc/php.ini'],
  }
}

class mysql {
  package {'mysql':
    ensure => 'present',
    before => Package['mysql-server'],
  }

  package {'mysql-server':
    ensure => 'present',
  }

  service {'mysqld':
    ensure => running,
    enable => true,
    require => Package['mysql-server'],
  }

  exec { "create-db":
    command => "/usr/bin/mysql -uroot -e \"drop database if exists drupal; create database drupal;\"",
    require => Service["mysqld"]
  }

  # exec { "create-db-user":
  #   command => "/usr/bin/mysql -uroot -e \"create user ``leadgenplatform``@``localhost`` identified by 'fierce123'; grant all on leadgenplatform_drupal.* to ``leadgenplatform``@``localhost``; grant all on leadgenplatform.* to ``leadgenplatform``@``localhost``; flush privileges;\"",
  #   require => Exec['create-dbs']
  # }
}

class iptables {
  service {'iptables':
    ensure => stopped,
    enable => false,
  }
}

class hosts {
  exec {'add-db01-to-hosts':
    command => '/bin/echo "127.0.0.1  db01" >> /etc/hosts'
  }
}

include updates
include php
include pear
include drush
include httpd
include mysql
include iptables
# include hosts



# import a DB dump

# use the vagrant user for everything?


# download a files directory and symlink it
# setup virtual hosts (look into vhosts_alias) - copy sites.d files to the right place and modify httpd.conf
# correct any ownership issues with the files dir

# disable selinux - test if it hates the /var/www/html symlink

# install rubygems, sass, compass
# in drupal itself, disable caching and apachsolr write mode


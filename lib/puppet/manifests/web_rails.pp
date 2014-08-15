# These manifests are usually scp'd to ec2 by a fog script, and then run programatically.
# To run manually, ssh into the box you want to run it on and run:
# cd /opt/apps/entelo/current
# sudo puppet apply --modulepath=/opt/apps/entelo/current/lib/puppet/modules -v lib/puppet/manifests/common.pp

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

group { "puppet":
  ensure => "present",
}

exec { "apt-update":
  command => "/usr/bin/apt-get update",
  require => Group["puppet"]
}

file { "/etc/puppet.conf":
  owner => 'root',
  group => 'root',
  mode => '644',
  content => template("common/puppet.conf"),
}

# include defaults
include fail2ban
include tzdata
include redis
include unattended_upgrades

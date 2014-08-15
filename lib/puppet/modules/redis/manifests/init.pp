class redis {
  package { "redis-server":
    ensure => present,
  }

  file { "redis-conf":
    path    => "/etc/redis/redis.conf",
    content => template("redis/redis.conf.erb"),
    owner => 'root',
    group => 'root',
    mode => 644,
    require => Package["redis-server"],
  }

  service { "redis-server":
    ensure => running,
    require => File["redis-conf"],
  }
}

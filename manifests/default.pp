Package { ensure => installed }

Exec['apt_update'] -> Package <| |>

apt::source { 'pgdg':
  location => "http://apt.postgresql.org/pub/repos/apt/",
  release => "$lsbdistcodename-pgdg",
  key => 'ACCC4CF8',
}

package { ['postgresql-9.2', 'postgresql-server-dev-9.2', 'postgresql-contrib-9.2']:
  require => Apt::Source['pgdg'],
}

file { '/etc/sysctl.d/30-postgresql-shm.conf':
  ensure => present,
  content => "\
kernel.shmmax = 335544320
",
  notify => Exec['reload_sysctl'],
}

exec { 'reload_sysctl':
  command => 'cat /etc/sysctl.d/*.conf /etc/sysctl.conf | sysctl -e -p -',
  path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
  refreshonly => true,
}

package { 'build-essential': }
package { 'curl': }
package { 'git': }
package { 'python-psycopg2': }
package { 'unzip': }

class { 'my-hadoop': }
class { 'my-hadoop::flume': }
class { 'my-hadoop::hbase': }

# pointing to 127.0.1.1 breaks hbase
host { "localhost":
  ip => '127.0.0.1',
  host_aliases => ["$hostname"],
}

host { "$hostname":
  ensure => absent,
}


exec { "git clone git://github.com/mpihlak/pg_logforward.git":
  path => ['/bin', '/usr/bin'],
  user => 'vagrant',
  cwd => '/home/vagrant',
  creates => '/home/vagrant/pg_logforward',
  provider => shell,
}

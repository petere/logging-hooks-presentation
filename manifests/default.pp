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

package { 'build-essential': }
package { 'curl': }
package { 'git': }
package { 'unzip': }

class { 'my-hadoop': }
class { 'my-hadoop::flume': }

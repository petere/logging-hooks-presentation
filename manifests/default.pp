Package { ensure => installed }

apt::source { 'pgdg':
  location => "http://apt.postgresql.org/pub/repos/apt/",
  release => "$lsbdistcodename-pgdg",
  key => 'ACCC4CF8',
}

package { 'postgresql-9.2':
  require => Apt::Source['pgdg'],
}

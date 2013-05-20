class my-hadoop::hbase {

  download { "/tmp/hbase.tar.gz":
    uri => "https://archive.apache.org/dist/hbase/hbase-0.94.7/hbase-0.94.7.tar.gz",
  }

  exec { "tar -C /opt -x -z -f /tmp/hbase.tar.gz":
    creates => '/opt/hbase-0.94.7',
    path => ['/bin', '/usr/bin'],
    require => Download['/tmp/hbase.tar.gz'],
  }

  file { '/opt/hbase':
    ensure => link,
    target => '/opt/hbase-0.94.7',
  }

  file { '/etc/profile.d/hbase-env.sh':
    ensure => present,
    content => "\
export HBASE_HOME=/opt/hbase
export HBASE_LOG_DIR=/tmp
",
  }
}

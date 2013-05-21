class my-hadoop::flume {

  download { "/var/tmp/flume.tar.gz":
    uri => "https://archive.apache.org/dist/flume/1.3.1/apache-flume-1.3.1-bin.tar.gz",
  }

  exec { "tar -C /opt -x -z -f /var/tmp/flume.tar.gz":
    creates => '/opt/apache-flume-1.3.1-bin',
    path => ['/bin', '/usr/bin'],
    require => Download['/var/tmp/flume.tar.gz'],
  }

  file { '/opt/flume':
    ensure => link,
    target => '/opt/apache-flume-1.3.1-bin',
  }
}

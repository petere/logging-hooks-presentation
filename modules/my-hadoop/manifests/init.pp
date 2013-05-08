class my-hadoop {

  package { 'openjdk-7-jdk': }

  package { 'hadoop':
    source => '/vagrant/hadoop_1.0.4-1_x86_64.deb',
    provider => 'dpkg',
    require => Package['openjdk-7-jdk'],
  }

  file { '/usr/lib/jvm/java-6-sun':
    ensure => link,
    target => '/usr/lib/jvm/java-7-openjdk-amd64',
    require => Package['openjdk-7-jdk'],
  }

  file { '/var/log/hadoop/root':
    ensure => directory,
    owner => root,
    group => hadoop,
    mode => 'ug=rwx,o=rx',
  }

  file {
    '/etc/hadoop/core-site.xml':
      ensure => present,
      source => 'puppet:///modules/my-hadoop/core-site.xml';

    '/etc/hadoop/hdfs-site.xml':
      ensure => present,
      source => 'puppet:///modules/my-hadoop/hdfs-site.xml';

    '/etc/hadoop/mapred-site.xml':
      ensure => present,
      source => 'puppet:///modules/my-hadoop/mapred-site.xml';
  }

  exec { 'format_namenode':
    command => 'hadoop namenode -format',
    path => ['/usr/bin'],
    creates => '/var/tmp/hadoop/dfs/name/current',
    user => 'hdfs',
    require => File['/etc/hadoop/hdfs-site.xml'],
  }

  service {
    ['hadoop-namenode', 'hadoop-datanode']:
      ensure => running;
  }

  #$ sudo -u hdfs hadoop fs -mkdir /mapred
  #$ sudo -u hdfs hadoop fs -chown mapred:hadoop /mapred

  service {
    ['hadoop-jobtracker', 'hadoop-tasktracker']:
      ensure => running;
  }
}

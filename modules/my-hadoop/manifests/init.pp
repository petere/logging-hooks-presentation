class my-hadoop {

  package { 'wget': }

  define download ($uri, $timeout = 300) {
    exec {
      "download $uri":
        command => "wget -q '$uri' -O $name",
        path => ['/usr/bin'],
        creates => $name,
        timeout => $timeout,
        require => Package[ "wget" ],
    }
  }

  package { 'openjdk-7-jdk': }

  download { "/tmp/hadoop.deb":
      uri => "https://archive.apache.org/dist/hadoop/core/hadoop-1.0.4/hadoop_1.0.4-1_$architecture.deb",
  }

  package { 'hadoop':
    source => '/tmp/hadoop.deb',
    provider => 'dpkg',
    require => [Package['openjdk-7-jdk'], Download['/tmp/hadoop.deb'], File['/usr/lib/jvm/java-6-sun']],
  }

  file { '/usr/lib/jvm/java-6-sun':
    ensure => link,
    target => "/usr/lib/jvm/java-7-openjdk-$architecture",
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
      require => Package['hadoop'],
      source => 'puppet:///modules/my-hadoop/core-site.xml';

    '/etc/hadoop/hdfs-site.xml':
      ensure => present,
      require => Package['hadoop'],
      source => 'puppet:///modules/my-hadoop/hdfs-site.xml';

    '/etc/hadoop/mapred-site.xml':
      ensure => present,
      require => Package['hadoop'],
      source => 'puppet:///modules/my-hadoop/mapred-site.xml';
  }

  exec { 'format_namenode':
    command => 'hadoop namenode -format',
    path => ['/bin', '/usr/bin'],
    creates => '/var/tmp/hadoop/dfs/name/current',
    user => 'hdfs',
    require => File['/etc/hadoop/hdfs-site.xml'],
  }

  service { 'hadoop-namenode':
    require => [Package['hadoop'], File['/etc/hadoop/core-site.xml', '/etc/hadoop/hdfs-site.xml']],
    hasstatus => false,
    pattern => 'proc_namenode',
    ensure => running,
  }

  service { 'hadoop-datanode':
    require => [Package['hadoop'], File['/etc/hadoop/core-site.xml', '/etc/hadoop/hdfs-site.xml']],
    hasstatus => false,
    pattern => 'proc_datanode',
    ensure => running,
  }

  #$ sudo -u hdfs hadoop fs -mkdir /mapred
  #$ sudo -u hdfs hadoop fs -chown mapred:hadoop /mapred

  #service {
  #  ['hadoop-jobtracker', 'hadoop-tasktracker']:
  #    require => [Package['hadoop'], File['/etc/hadoop/core-site.xml', '/etc/hadoop/mapred-site.xml']],
  #    ensure => running;
  #}
}

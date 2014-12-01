class nrsysmond::repo::debian (
  $apt_repo = $::nrsysmond::params::apt_repo
) inherits nrsysmond::params {
  file { '/etc/apt/sources.list.d/newrelic.list':
    ensure => present,
    content => "deb ${apt_repo} newrelic non-free\n",
  }

  exec { 'load apt key':
    path    => '/usr/bin:/bin',
    command => 'wget -O- http://download.newrelic.com/548C16BF.gpg | apt-key add -',
    unless  => 'apt-key list | grep 548C16BF',
  }

  exec {'update apt':
    command     => 'apt-get update',
    path        => '/usr/bin:/bin',
    require     => Exec['load apt key'],
    refreshonly => true,
    subscribe   => File['/etc/apt/sources.list.d/newrelic.list'],
  }
}

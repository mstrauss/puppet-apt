# $cache: ip and port of apt-cacher-ng, e.g. '10.1.0.12:3142'
class apt( $autoupdate = false, $autoupdate_method = 'unattended-upgrade', $cache = undef ) {

  if( defined( editfile ) ) {
    # without editfile we do not touch the existing config
    apt::conf { '90aptcache':
        content => "// managed by puppet
    Acquire::http { Proxy \"http://${cache}\"; };
    ",
        ensure => $cache ? {
          undef   => absent,
          default => present,
        },
      }
  }
  
  if $cache != undef {
    $_cache = "${cache}/"
    # need to make sure, that we do not use the proxy in the sources.list file (e.g. from unattended setup!)
    editfile { 'clean sources.list':
      path   => '/etc/apt/sources.list',
      exact  => true,
      match  => $_cache,
      match_is_string => true,
      ensure => absent,
    }
  }
  
  if $autoupdate == true {
    
    case $autoupdate_method {
      'unattended-upgrade': {
        class { 'apt::unattended-upgrade::automatic': ensure => present }
        class { 'apt::cron-apt': ensure => absent }
      }
      'cron-apt': {
        class { 'apt::unattended-upgrade::automatic': ensure => absent }
        class { 'apt::cron-apt': ensure => present }
      }
      default: {
        class { 'apt::unattended-upgrade::automatic': ensure => absent }
        class { 'apt::cron-apt': ensure => absent }
      }
    }
  }

  Package {
    require => Exec["apt-get_update"]
  }
  
  # all our files belong root
  File {
    owner   => root,
    group   => root,  
  }

  # apt support preferences.d since version >= 0.7.22
  case $::lsbdistcodename { 
    /lucid|squeeze/ : {

      file {"/etc/apt/preferences":
        ensure => absent,
      }

      file {"/etc/apt/preferences.d":
        ensure  => directory,
        mode    => 755,
        recurse => true,
        purge   => true,
        force   => true,
      }
    }
  }

  # ensure only files managed by puppet be present in this directory.
  file { "/etc/apt/sources.list.d":
    ensure  => directory,
    source  => "puppet:///modules/apt/empty/",
    recurse => true,
    purge   => true,
    force   => true,
    ignore  => ".placeholder",
  }

  apt::conf {"10periodic":
    ensure => present,
    source => "puppet:///modules/apt/10periodic",
  }

  exec { "apt-get_update":
    command => "/usr/bin/apt-get update",
    refreshonly => true,
  }
}

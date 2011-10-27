class apt( $autoupdate = false, $autoupdate_method = 'unattended-upgrade' ) {

  if $autoupdate == true {
    
    case $autoupdate_method {
      'unattended-upgrade': {
        class { 'apt::unattended-upgrade::automatic': ensure => present }
      }
      default: {
        class { 'apt::unattended-upgrade::automatic': ensure => absent }
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

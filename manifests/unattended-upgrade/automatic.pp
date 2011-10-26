class apt::unattended-upgrade::automatic( $ensure = present ) {
  
  class { 'apt::unattended-upgrade': ensure => $ensure }
  # Class['apt::unattended-upgrade'] -> Class['apt::unattended-upgrade::automatic']
  
  # common settings (Debian && Ubuntu)
  apt::conf{"99unattended-upgrade":
    ensure  => $ensure,
    source  => 'puppet:///modules/apt/99unattended-upgrade',
  }

  # distribution (Debian || Ubuntu) dependent settings
  if $::lsbdistid {
    apt::conf{"50unattended-upgrades":
      ensure  => $ensure,
      content => template("apt/unattended-upgrades.${::lsbdistid}.erb"),
    }
  }
}

class apt::unattended-upgrade::automatic inherits apt::unattended-upgrade {
  apt::conf{"99unattended-upgrade":
    ensure  => present,
    source  => 'puppet:///modules/apt/99unattended-upgrade',
  }

  if $::lsbdistid {
    apt::conf{"50unattended-upgrades":
      ensure  => present,
      # ensure  => absent,
      content => template("apt/unattended-upgrades.${::lsbdistid}.erb"),
    }
  }
}

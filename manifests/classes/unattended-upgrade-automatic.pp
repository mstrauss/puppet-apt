class apt::unattended-upgrade::automatic inherits apt::unattended-upgrade {
  apt::conf{"99unattended-upgrade":
    ensure  => present,
    content => "APT::Periodic::Unattended-Upgrade \"1\";\n",
  }

  if $::lsbdistid {
    apt::conf{"50unattended-upgrades":
      ensure  => present,
      # ensure  => absent,
      content => template("apt/unattended-upgrades.${::lsbdistid}.erb"),
    }
  }
}

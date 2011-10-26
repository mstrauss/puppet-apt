class apt::unattended-upgrade {
  package {"unattended-upgrades":
    ensure => present,
  }
  
  # for the mail-sending feature
  package { 'heirloom-mailx': ensure => present }

}

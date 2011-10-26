class apt::unattended-upgrade( $ensure = present ) {
  package {"unattended-upgrades":
    ensure => $ensure,
  }
  
  # for the mail-sending feature
  package { 'heirloom-mailx': ensure => $ensure }

}

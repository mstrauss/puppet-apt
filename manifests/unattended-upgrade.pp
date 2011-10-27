class apt::unattended-upgrade( $ensure = present ) {
  package {"unattended-upgrades":
    ensure => $ensure ? {
      absent  => purged,
      default => $ensure,
    },
  }
  
  if $ensure == present {
    # for the mail-sending feature
    package { 'heirloom-mailx': ensure => present }
  }

}

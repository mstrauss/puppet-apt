class apt::cron-apt( $ensure = present, $mailon = 'upgrade' ) {
  
  package { 'cron-apt':
    ensure => $ensure ? {
      absent  => purged,
      default => present,
    },
  }

 # enable dist-upgrade action
  file { '/etc/cron-apt/action.d/5-upgrade':
    require => Package[cron-apt],
    content => "dist-upgrade -y -o APT::Get::Show-Upgraded=true\n",
    ensure  => $ensure,
    mode    => 644,
    owner   => root,
    group   => root,
  }

  
  if $ensure == present {
    editfile { 'configure MAILON setting':
      require => Package[cron-apt],
      path    => '/etc/cron-apt/config',
      match   => '/^#?\s*MAILON=/',
      ensure  => "MAILON=\"${mailon}\"",
    }

    # download files but without output
    # we replace: dist-upgrade -d -y -o APT::Get::Show-Upgraded=true
    # with: dist-upgrade -d -y
    editfile { '3-download':
      require => Package[cron-apt],
      path   => '/etc/cron-apt/action.d/3-download',
      match  => '/^dist-upgrade/',
      ensure => 'dist-upgrade -d -y',
    }
    # for the mail-sending feature
    package { 'heirloom-mailx': ensure => present }
  }

}

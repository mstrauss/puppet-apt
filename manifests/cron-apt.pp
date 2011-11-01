class apt::cron-apt( $ensure = present, $mailon = 'upgrade' ) {
  
  package { 'cron-apt':
    ensure => $ensure ? {
      absent  => purged,
      default => $ensure,
    },
  }

  # defaults
  Editfile { ensure  => $ensure, require => Package[cron-apt] }
  File     { ensure  => $ensure, require => Package[cron-apt],
             mode => 644, owner => root, group => root }
  
  editfile { 'configure MAILON setting':
    path   => '/etc/cron-apt/config',
    match  => '^#?\s*MAILON=',
    ensure => "MAILON=\"${mailon}\"",
  }

  # download files but without output
  # we replace: dist-upgrade -d -y -o APT::Get::Show-Upgraded=true
  # with: dist-upgrade -d -y
  editfile { '3-download':
    path   => '/etc/cron-apt/action.d/3-download',
    match  => '^dist-upgrade',
    ensure => 'dist-upgrade -d -y',
  }
  
  # enable dist-upgrade action
  file { '/etc/cron-apt/action.d/5-upgrade':
    content => "dist-upgrade -y -o APT::Get::Show-Upgraded=true\n",
  }
  
  if $ensure == present {
    # for the mail-sending feature
    package { 'heirloom-mailx': ensure => present }
  }
  
}

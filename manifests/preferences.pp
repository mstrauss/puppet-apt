define apt::preferences($ensure="present", $package="", $pin, $priority) {

  $pkg = $package ? {
    "" => $name,
    default => $package,
  }

  # apt support preferences.d since version >= 0.7.22
  if $::apt_supports_preferences_d == true {
    file {"/etc/apt/preferences.d/$name":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => 644,
      content => template("apt/preferences.erb"),
      before  => Exec["apt-get_update"],
      notify  => Exec["apt-get_update"],
    }
  } elsif $::apt_supports_preferences_d == false {

    common::concatfilepart { $name:
      ensure  => $ensure,
      manage  => true,
      file    => "/etc/apt/preferences",
      content => template("apt/preferences.erb"),
      before  => Exec["apt-get_update"],
      notify  => Exec["apt-get_update"],
    }
    
  } else {
    warn( "apt::preferences cannot be set on host ${::fqdn}: do not know if preferences.d is supported.")
  }

}

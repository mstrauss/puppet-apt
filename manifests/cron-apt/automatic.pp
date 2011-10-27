# This class is intended to be used when you don't wanna use class parameters
# on the apt base class.  It's kind of a temporary helper class.
# Usage:
#   class { 'apt': }
#   class { 'apt::cron-apt::automatic': }
class apt::cron-apt::automatic {
  
  class { 'apt::unattended-upgrade::automatic': ensure => absent }
  class { 'apt::cron-apt': ensure => present }
  
}

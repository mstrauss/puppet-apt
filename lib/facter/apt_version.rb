module Facter::Apt
  class << self
    def apt_version
      `apt-config --version`.strip =~ /^apt ([0-9.]+)/
      $1
    end
    
    def apt_supports_preferences_d
      Gem::Version.new( apt_version ) >= Gem::Version.new( '0.7.22' )
    end
  end
end

Facter.add(:apt_version) do
  confine :operatingsystem => ['Debian', 'Ubuntu']
  setcode { Facter::Apt.apt_version }
end

Facter.add(:apt_supports_preferences_d) do
  confine :operatingsystem => ['Debian', 'Ubuntu']
  setcode { Facter::Apt.apt_supports_preferences_d }
end

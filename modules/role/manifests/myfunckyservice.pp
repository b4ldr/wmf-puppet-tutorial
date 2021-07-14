# this is a very simple role.  Roles should only contain profiles
# and they must contain a call to system::role
class role::myfunckyservice  {

  # this define adds some meta data to server motd and also helps us classify
  # nodes elses where in puppet, puppetdb
  system::role { 'mfs': description => 'myfunckyservice' }
  # This si the main profile to buiuld our standard base system and includes thinsg
  # like configuereing apt, nameservers, useres, puppet etc
  include profile::standard
  # This configueres the basic set of firewall rules
  include profile::base::firewall
  # Here we add our profile
  include profile::myfunckyservice
}

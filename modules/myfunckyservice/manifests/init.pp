class myfunckyservice (
  # The String keyword here means puppet will fail if you try to pass anythig 
  # which is not a string
  # String is one of many tyeps built into puppet
  # https://puppet.com/docs/puppet/7/lang_data_type.html
  String           $owner = 'root',
  String           $group = 'root',
  # this is a custom type provided bye the puppet;abs module stdlib
  # custom types will always be namespace (i.e. have a double colon)
  # In this case the custom type is c$an alias to a regex type
  # https://github.com/puppetlabs/puppetlabs-stdlib/blob/main/types/filemode.pp
  Stdlib::Filemode $mode  = '0500',
) {
  # It is quite common for the config file to be used in multiple places
  # as such i tend to store it in a variable at the top so we can just refrence that
  # also makes changing this in the future easier
  # We could also have this as a parameter however i find that in production environments
  # the config file path is rarely overridden
  $config_file = '/etc/myfunckyservice/config.yaml'
  ensure_packages('myfunckyservice')
  file {$config_file:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    source  => 'puppet:///modules/config.yaml',
    require => Package['myfunckyservice'],
  }
  # manage the service
}

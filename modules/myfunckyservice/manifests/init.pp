# @summary A simple class example class
#  the comments here use YARD tags to document the class, more information on the avalible tags
#  can be found on the puppet labs docs
#  https://puppet.com/docs/puppet/7/puppet_strings.html
# @param api_key the apik key for service
# @param api_uri the uri for service
# @param ensure the ensureable parameter
# @param owner all files created by this module will be owned by this user
# @param group all files created by this module will be owned by this group
# @param mode all files created by this module will be managed with this mode
# @param access_list an array of ip addresses by myfunckyservice
# @param datasets an hash of datasets
# @example
#  class {'myfunckyservice':
#    api_key => 'secret_key',
#  }
class myfunckyservice (
  # As we are now casting the value to Sensetive in hire we also need to update the type checking here
  Sensitive[String[1]]                   $api_key,
  Wmflib::Ensure                         $ensure      = 'present',
  Stdlib::Httpurl                        $api_uri     = 'https://mfs.example.org',
  String                                 $owner       = 'root',
  String                                 $group       = 'root',
  Stdlib::Filemode                       $mode        = '0500',
  Array[Stdlib::IP::Address]             $access_list = [],
  Hash[String, Myfunckyservice::Dataset] $datasets    = {},
) {
  $config_file = '/etc/myfunckyservice/config.yaml'
  $config = {
    'api_key'     => $api_key,
    'api_uri'     => $api_uri,
    'access_list' => $access_list,
    'datasets'    => $datasets,
  }
  ensure_packages('myfunckyservice', {'ensure' => $ensure})
  file {$config_file:
    ensure  => stdlib::ensure($ensure, 'file'),
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $config.to_yaml,
    require => Package['myfunckyservice'],
    notify  => Service['myfunckyservice'],
  }
  service {'myfunckyservice':
    ensure  => stdlib::ensure($ensure, 'service'),
    enabled => true,
  }
}

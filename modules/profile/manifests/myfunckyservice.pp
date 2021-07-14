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
#  class {'profile::myfunckyservice':
#    api_key => 'secret_key',
#  }
class profile::myfunckyservice (
  Wmflib::Ensure                         $ensure      = lookup('profile::myfunckyservice::ensure'),
  # As we are now casting the value to Sensetive in hire we also need to update the type checking here
  Sensitive[String[1]]                   $api_key     = lookup('profile::myfunckyservice::api_key'),
  Stdlib::Httpurl                        $api_uri     = lookup('profile::myfunckyservice::api_uri'),
  String                                 $owner       = lookup('profile::myfunckyservice::owner'),
  String                                 $group       = lookup('profile::myfunckyservice::group'),
  Stdlib::Filemode                       $mode        = lookup('profile::myfunckyservice::mode'),
  Array[Stdlib::IP::Address]             $access_list = lookup('profile::myfunckyservice::access_list'),
  Hash[String, Myfunckyservice::Dataset] $datasets    = lookup('profile::myfunckyservice::datasets'),
) {
  class {'myfunckyservice':
    ensure      => $ensure,
    api_key     => $api_key,
    owner       => $owner,
    group       => $group,
    mode        => $mode,
    access_list => $access_list,
    datasets    => $datasets,
  }

  ferm::service{'myfunckyservice api service':
    proto  => 'tcp',
    port   => '443',
    srange => '$DOMAIN_NETWORKS',
  }
  monitoring::service { 'myfunckyservice-api':
    description   => "${api_uri}:443 internal",
    check_command => "check_https_client_auth_puppet!${api_uri}!/!200!HEAD",
    notes_url     => 'https://wikitech.wikimedia.org/wiki/Myfunckyservice',
  }

}

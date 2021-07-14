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
  # Theses parameters are copy/pasted from the module signiture, you often want to expose the same set of variables the module has
  # to the profile, however in some cases the defaults will never need to change so don't copy blindly.
  # We have moved ensure to the top of the parameter list is this is the prefer style when all paramaters have a default
  # api_key has a default now and we must pull a value from profile::myfunckyservice::api_key somewhere in hiera
  # or puppet will fail to compile
  Wmflib::Ensure                         $ensure      = lookup('profile::myfunckyservice::ensure'),
                                                        # The WMF puppet policy specifies that all parameters must be explicitly
                                                        # looked up using the lookup command.  Ideally the key should be namespaced
                                                        # with the calling profile as as we do below, however in some cases your may
                                                        # want to lookup a global value
                                                        # We mentioned before that this value should be secret, we will cover how we
                                                        # ensure that later on in the hiera commits
  String                                 $api_key     = lookup('profile::myfunckyservice::api_key'),
  Stdlib::Httpurl                        $api_uri     = lookup('profile::myfunckyservice::api_uri'),
  String                                 $owner       = lookup('profile::myfunckyservice::owner'),
  String                                 $group       = lookup('profile::myfunckyservice::group'),
  Stdlib::Filemode                       $mode        = lookup('profile::myfunckyservice::mode'),
  Array[Stdlib::IP::Address]             $access_list = lookup('profile::myfunckyservice::access_list'),
  Hash[String, Myfunckyservice::Dataset] $datasets    = lookup('profile::myfunckyservice::datasets'),
) {
  # Again just pass theses values through
  class {'myfunckyservice':
    ensure      => $ensure,
    api_key     => $api_key,
    owner       => $owner,
    group       => $group,
    mode        => $mode,
    access_list => $access_list,
    datasets    => $datasets,
  }

  # As mentioned previoulsy we try to keep WMF specific code in the profile
  # Here we are calling ferm with DOMAIN_NETWORKS which is WMF specific and defines
  # either the list of cloud service networks or production networks depending on which
  # environment you are running on
  ferm::service{'myfunckyservice api service':
    proto  => 'tcp',
    port   => '443',
    srange => '$DOMAIN_NETWORKS',
  }
  # This define creates a check for our endpoint, the monitoring module is very specific to
  # WMF so this is also a good candidate to go in a profile
  monitoring::service { 'myfunckyservice-api':
    description   => "${api_uri}:443 internal",
    check_command => "check_https_client_auth_puppet!${api_uri}!/!200!HEAD",
    notes_url     => 'https://wikitech.wikimedia.org/wiki/Myfunckyservice',
  }

}

class myfunckyservice (
  String                                 $api_key,
  Stdlib::Httpurl                        $api_uri,
  # Wmflib::Ensure is a custom type provided by the wmflib module
  # this is just an alias to Enum['present', 'absent']
  # https://github.com/wikimedia/puppet/blob/production/modules/wmflib/types/ensure.pp
  Wmflib::Ensure                         $ensure      = 'present',
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
  # ensure_packages takes an optional second argument which can be used to override
  # the default options passed to the package type.  here we use it to pass the ensure
  # parameter.  It is worth noting ultimatly all definitions of the `myfunckyservice`
  # package must be defined with the same set of parameteres every where.  the fuction below
  # will create the following resource
  # package{'myfunckyservice':
  #   ensure => present
  # }
  # if we have a definitions for ensure_packages('myfunckyservice') else where in the manifest
  # and we set this classes parameter to 'absent' then we would end up with conflict as the
  # ensure parmeter of the two definitions don't match for this reason and its often desirable to
  # skip making the package install ensurable and just live with the fact that we have some extra
  # packages installed.  this is something left to to the module authors
  ensure_packages('myfunckyservice', {'ensure' => $ensure})
  file {$config_file:
    # Stdlib::ensure is a function which takes the following types
    # Variant[Boolean, Enum[''abesnt', 'present']
    # it then returns the resources specific ensure value.  in this case it will return
    #   * 'file' -  when passed either present of true
    #   * 'absent' -  when passed either absent of false
    # This helper function allows use to use the same ensure value on many resources.
    # in most cases you can also simply pass $ensure directly and puppet
    # will do the right thing.  however we can be a bit more specific with the helper function
    # for instance if we simply pass 'present' to the ensure value of the file resource then puppet
    # will just ensure there is a file like object which could be a directory, link of file.
    # By passing a value of 'file' as this helper function dose we ensure the resource create is a real file
    ensure  => stdlib::ensure($ensure, 'file'),
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $config.to_yaml,
    require => Package['myfunckyservice'],
    notify  => Service['myfunckyservice'],
  }
  service {'myfunckyservice':
    # In this case it will return
    #   * 'running' -  when passed either present of true
    #   * 'stopped' -  when passed either absent of false
    # In the specific case of the service resource we note that that it dosn't accept
    # ensure values of 'present', 'absent' as such passing through the ensure value without
    # the helper function or some other manipulation then compilation would fail
    ensure  => stdlib::ensure($ensure, 'service'),
    enabled => true,
  }
}

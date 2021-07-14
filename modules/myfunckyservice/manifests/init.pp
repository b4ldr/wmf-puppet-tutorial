class myfunckyservice (
  String                                 $api_key,
  Stdlib::Httpurl                        $api_uri,
  String                                 $owner       = 'root',
  String                                 $group       = 'root',
  Stdlib::Filemode                       $mode        = '0500',
  Array[Stdlib::IP::Address]             $access_list = [],
  # As we know whet the data structre for datasets should look like
  # lets use a custom type and validate it
  Hash[String, Myfunckyservice::Dataset] $datasets    = {},
) {
  $config_file = '/etc/myfunckyservice/config.yaml'
  $config = {
    'api_key'     => $api_key,
    'api_uri'     => $api_uri,
    'access_list' => $access_list,
    'datasets'    => $datasets,
  }
  ensure_packages('myfunckyservice')
  file {$config_file:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $config.to_yaml,
    require => Package['myfunckyservice'],
  }
  # manage the service
}

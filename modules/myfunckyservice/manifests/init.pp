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
    # the notify keeword is used to "refresh" another resource,  not all resources
    # are refreshable and the ones that are do different things depending on the type.
    # when refreshing (sending a notify) to a service resource on a sytemd system it will do
    # `systemctl restart $service` which in the vast majority of cases is what you want to do
    notify  => Service['myfunckyservice'],
  }
  service {'myfunckyservice':
    ensure      => running,
    enabled     => true,
    # we could use subscribe here like the example below but notify
    # like `require` is more common
    # subscribe => File[$config_file]
  }
}

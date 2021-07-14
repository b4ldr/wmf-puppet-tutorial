class myfunckyservice (
  # As this parameter has no default value it means it is mandatory
  String           $api_key,
  # this is another stdlib type see if you can find the definition
  # (hint in the types dir of the stdlib module)
  Stdlib::Httpurl            $api_uri,
  String                     $owner       = 'root',
  String                     $group       = 'root',
  Stdlib::Filemode           $mode        = '0500',
  # We know that we want an array of ip addresses so lets make this define stricter
  # Stdlib::IP::Address comes is another custom type from stdlib.  It matches any valid
  # ipv4/6 ip address or prefix.  its a fairly complex type with some horrible regex but
  # a good example of what custome types are capable of
  # https://github.com/puppetlabs/puppetlabs-stdlib/blob/main/types/ip/address.pp
  # (you will need to recurse into all the variant types to get a full grasp)
  Array[Stdlib::IP::Address] $access_list = [],
  # We also make this a bit stricter however in the next commit we will add a custom type here
  Hash[String, Hash]         $datasets    = {},
) {
  $config_file = '/etc/myfunckyservice/config.yaml'
  # its very common to see software use a yaml config file, as this is structured
  # data its much easier to create the necessary structure and just covert it to yaml
  # instead of trying to write out valid yaml in erb
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
    # `to_yaml` is a function provided by stdlib which take a puppet variables and
    # returns a valid yaml as a string
    content => $config.to_yaml,
    require => Package['myfunckyservice'],
  }
  # manage the service
}

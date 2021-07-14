class myfunckyservice (
  # As this parameter has no default value it means it is mandatory
  String           $api_key,
  # this is another stdlib type see if you can find the definition
  # (hint in the types dir of the stdlib module)
  Stdlib::Httpurl  $api_uri,
  String           $owner       = 'root',
  String           $group       = 'root',
  Stdlib::Filemode $mode        = '0500',
  # By using Array and a default of [] we essentially make this param
  # optional. will cover more advance use cases in further commits
  Array            $access_list = [],
  # similar to above we default this to an empty hash
  Hash             $datasets    = {},
) {
  $config_file = '/etc/myfunckyservice/config.yaml'
  ensure_packages('myfunckyservice')
  file {$config_file:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    # we change this here to use the content param and the template function.
    # When using the source parameter puppet buts a reference to a file source location
    # in the catalog.  This can be a http address a local file one the host or a puppet uri
    # (by far the most common).  This instructs the puppet agent to fetch the file as it processes
    # the catalog.
    # the content parameter on the other hand tags a string and ads the raw string directly into the
    # catalog (this means you can see diffs in pcc when using content but you cant using source)
    #
    # The template function pareses an erb file and return the parsed template as a string
    # notice in this case we have to use the module name in the call to template and we drop
    # the word 'modules'.  this is jut the way it is.  this will expect to fine a template in
    # modules/myfunckyservice/templates/config.yaml.erb
    # if we left out the module name i.e. `template('config.yaml.erb')` the template would be
    # pulled from `templates/config.yaml.erb` there is no templates dir in the ops puppet control
    # repo and you are unlikely to ever need to put  template file there
    content => template('myfunckyservice/config.yaml.erb'),
    require => Package['myfunckyservice'],
  }
  # manage the service
}

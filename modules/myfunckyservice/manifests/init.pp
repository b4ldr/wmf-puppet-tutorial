class myfunckyservice (
) {
  ensure_packages('myfunckyservice')
  file {'/etc/myfunckyservice/config.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0500',
    # this file will be picked up from the following path
    # modules/myfunckyservice/files/config.yaml
    # if you forget the word modules i.e.
    # puppet://config.yaml'
    # then the file will be source from
    # files/config.yaml
    source  => 'puppet:///modules/config.yaml',
    # this enures the myfunckyservice package resource
    # (which is created using ensure_packages('myfunckyservice'))
    # is realized before _this_ resource
    require => Package['myfunckyservice'],
    # puppet also has a before keyword so we could ensure that _this_ resource
    # is realized before Package['myfunckyservice'] (which doesn't make senses here)
    # e.g.
    # before => Package['myfunckyservice'],
  }
  # write our the config file
  # manage the service
}

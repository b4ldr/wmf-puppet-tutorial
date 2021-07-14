class myfunckyservice (
) {
  # tl;dr prefer ensure_packages to using the package type directly unless
  # you have a valid reason.
  # we could use the package resource directly with something like
  # package{'myfunckyservice':
  #   ensure => 'installed'
  # }
  # however it is quite common for multiple modules to try and install the same package.
  # In puppet all resources have to be unique i.e. two instance of
  # package{'myfunckyservice'} in the same catalog will cause an error.
  # using ensure_packages gracefully handles this and ensures only one
  # package{'myfunckyservice'} exists in the manifest no matter how many modules
  # call ensure_packages('myfunckyservice')
  ensure_packages('myfunckyservice')
  # write our the config file
  # manage the service
}

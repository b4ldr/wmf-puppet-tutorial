This is probably not the best place to store your file you should probably
store it under the module specific files directory.

If you do need to use this global level file structure the need to be referenced as:
 puppet:///$filename

e.g. to access this README.md file one would use a resource like the following
file {'/tmp/README.md':
  ensure => 'file',
  source => 'puppet:///README.md'
}

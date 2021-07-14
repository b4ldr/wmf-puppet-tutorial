# Struct is lick a C struct or a python data class i.e. a named hash
type Myfunckyservice::Dataset::Mysql = Struct[{
  # The '1' here means the string mst be at least one character long
  query    => String[1],
  # this is a enum  which ecepst only one value
  engine   => Enum['myslq'],
  # the 32 here means the string can not be longer the 32 characters
  user     => String[1,32],
  # add a very basic passowrd policy
  password => String[16,128],
  host     => Stdlib::Host,

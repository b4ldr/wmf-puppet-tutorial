# here we create a varient resource which matches botht eh mysql and sqlite
# custome types.  in puppet code we can check which type is used by using
# TODO: need to check this ((its late)
# if $dataser ~= Myfunckyservice::Dataset::Sqlite { ... }
type Myfunckyservice::Dataset = Variant[
  Myfunckyservice::Dataset::Sqlite,
  Myfunckyservice::Dataset::Mysql,
]

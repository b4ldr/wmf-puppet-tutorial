# We are going to create a very simple wrapper profile all this class dose is define the api
# key and use the module defaults
class profile::myfunckyservice {

  # This looks like is should be secret so we probably shouldn't define that here???
  $api_key = 'hard coded value'
  class {'myfunckyservice':
    api_key => $api_key
  }

}

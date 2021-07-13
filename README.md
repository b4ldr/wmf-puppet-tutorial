# wmf-puppet-tutorial
a simple tutorial for adding to the wikimedia foundation puppet repo

This tutorial will walk a user through how to install a damon call myfunkysevrvice.

it is install via apt and has a simple yaml configueration file with the following structure

```yaml
api_key: secret_key
api_uri: https://api.example.org
access_list:
- 192.0.2.0/24
datasets:
  mysql:
    query: 'som string'
    engine: 'mysql'
    user: 'user'
    password: 'password'
    host: 'db.example.org'
  sqlite:
    path: /srv/db/myfunkysevrvice.db
```

This module should also ensure that the damone myfunkysevrviced is started

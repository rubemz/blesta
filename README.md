Blesta [![Blesta Build Status][Build Icon]][Build Status]
=========================================================
A Ruby library for working with the [Blesta Reseller API][].

Blesta has been tested on MRI 1.8.7, MRI 1.9.2 and MRI 1.9.3.

[Build Status]: http://travis-ci.org/site5/blesta
[Build Icon]: https://secure.travis-ci.org/site5/blesta.png?branch=master
[Blesta Reseller API]: http://www.blesta.com/wp-content/uploads/2009/12/Blesta_Reseller_API_Documentation.pdf

Install
-------

    gem install blesta
    bundle install

Configuration
-------------

```ruby
require 'blesta'

Blesta.config do |c|
  c.base_uri 'https://blestaapi.com' # Root level URI for blesta API
  c.uid      'uid'                   # Blesta reseller UID
  c.password 'topsecret'             # Blesta reseller password
end
```

Usage
-----

Get all licenses:

```ruby
license = Blesta::License.new
license.all
```

Search for a specific license:

```ruby
license.search "mydomain.com", :type => "domain"
license.search "1234567890AB", :type => "license"
```

Get the amount of credit in USD on the reseller account:

```ruby
credit = Blesta::Credit.new
credit.get_amount
```

Get a list of all of the packages this reseller account may add:

```ruby
packages = Blesta::Package.new
packages.all
```

Supported Methods
-----------------

This gem implements the blesta reseller's API v1.0.

It includes:

* *Get Credit.*
* *Get Licenses.*
* *Get Packages.*
* *Add License.*
* *Cancel License.*
* *Suspend License.*
* *Unsuspend License.*
* *Search Licenses.*
* *Update Domain.*

Tests
-----

Blesta uses rspec for tests. To run:

    bundle exec rake

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a
  commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2012 Site5.com. See LICENSE for details.

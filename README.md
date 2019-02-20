# Agave Ruby Client

| Project                | Agave Ruby Client |
| ---------------------- | ------------ |
| Gem name               | agave-client |
| License                | [BSD 3](https://github.com/italia/ruby-agave-client/blob/master/LICENSE) |
| Version                | [![Gem Version](https://badge.fury.io/rb/agave-client.svg)](https://badge.fury.io/rb/agave-client) |
| Continuous integration | [![Build Status](https://secure.travis-ci.org/italia/ruby-agave-client.svg?branch=master)](https://travis-ci.org/italia/ruby-agave-client) |
| Test coverate          | [![Coverage Status](https://coveralls.io/repos/github/italia/ruby-agave-client/badge.svg?branch=master)](https://coveralls.io/github/italia/ruby-agave-client?branch=master) |
| Credits                | [Contributors](https://github.com/italia/ruby-agave-client/graphs/contributors) |

CLI tool for AgaveCMS (https://github.com/italia/agavecms).

## How to run tests

Tests are run against a local copy of Agave running on port 3001.

The tests rely on the followoing seed data:

* an AccessToken `AGAVE_API_TOKEN`,
* a User associated with that AccessToken.

If you clean `spec/fixtures/vcr_cassettes`, to test the application you must run rspec with these enviroinments variables: `AGAVECMS_BASE_URL=http://agave.lvh.me:3001 AGAVE_API_TOKEN=rwtoken rspec`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/italia/ruby-agave-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [BSD 3-Clause License](https://opensource.org/licenses/BSD-3-Clause).

# Credits

Progetto sviluppato e mantenuto da [Cantiere Creativo <img src="https://www.cantierecreativo.net/images/illustrations/logo-07f378ea.svg"/>](https://www.cantierecreativo.net) per conto di [Developers Italia](https://developers.italia.it/)

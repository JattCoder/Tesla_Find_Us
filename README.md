# TeslaFindUs

Welcome to Tesla Find Us gem, this gem can build a route for tesla owners from point A to point B and it can search for superchargers with search, users can search for superchargers using city or state or zip-code.

When planning a route, Tesla Find Us will use Sorting Algorithem to find best route possible. It will make sure you have enough battery level to get to destination. If nessassary, it will provide the list of superchargers you need to make with information of how much of battery will be remaining on arrival, address of supercharger, how many slots are available and how much power can be withdrawn from each slot.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'Tesla_Find_us'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install Tesla_Find_us

## Usage

Excute Tesla_Find_Us:

    $ shotgun

Open weblink in Browser:

    $ localhost:9393

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/Tesla_Find_us.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

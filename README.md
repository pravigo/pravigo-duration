# Pravigo::Duration

extends ActiveSupport::Duration class to add iso8601 support

## Installation

Add this line to your application's Gemfile:

    gem 'pravigo-duration'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pravigo-duration

## Usage

###Example 1: subtract 2 time objects to get a duration

    irb
	irb(main):001:0> require 'pravigo/duration'
	=> true
    irb(main):002:0> t2 = Time.parse("2015-07-09T09:56:33Z")
    => 2015-07-09 09:56:33 UTC
    irb(main):003:0> t = Time.parse("2015-07-09T09:37:33Z")
    => 2015-07-09 09:37:33 UTC
    irb(main):004:0> d = Duration.new(t2-t)
    => 19 minutes

### Running RSPEC tests

From the root directory:

    rspec ./spec/duration_spec.rb -f documentation

or

    rake test

or 

    rake spec

## Contributing

1. Fork it ( http://github.com/pravigo/pravigo-duration/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

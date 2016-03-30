# Resque::Multifail

Allow Resque jobs to fail a few times before storing the failure.

## Background

At SparkSeat, we have a few scheduled resque jobs that fail occasionally.
If they have failed once but succeed on the next run, we don't care.
This gem allows us to specify that.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resque-multifail'
```

And then execute:

    $ bundle

## Usage

```
class ExampleJob
  extend Resque::Plugins::Multifail

  @queue = :test
  @allow_failures = 3

  # N.B, jobs with different arguments are handled separately by the gem.
  def self.perform(arg1, arg2)
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sparkseat/resque-multifail.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

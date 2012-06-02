# Pulse::Meter::Rails

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'pulse-meter-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pulse-meter-rails

## Usage

Create an initializer with the following config

    PulseToolbox.redis = Redis.new :host => "localhost", :port => 6379, :db => 2
    PulseToolbox::Server::Monitoring.use Rack::Auth::Basic do |username, password|
      username == 'admin'
    end

And mount monitoring server in your <tt>router.rb</tt>

    mount PulseToolbox::Server::Monitoring, :at => "/monitoring"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

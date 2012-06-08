# PulseToolbox
Pulse toolbox provides various metrics for your Rails application out of box.
It is based on [pulse-meter](https://github.com/savonarola/pulse-meter) gem.

Beeing added to Gemfile Pulse Toolbox allows you to mount monitoring page in 
your <tt>routes.rb</tt> file.

Requests processing times will be displayed there. You can also add custom
sensors to configuration to be displayed.


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

And mount monitoring server in your <tt>routes.rb</tt>

    mount PulseToolbox::Server::Monitoring, :at => "/monitoring"

Launch your application and visit <tt>/monitoring</tt>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

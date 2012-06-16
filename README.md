[![Build Status](https://secure.travis-ci.org/averyanov/pulse-meter-rails.png)](http://travis-ci.org/averyanov/pulse-meter-rails)

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

Or you can use generator to create initializer and add route:
    
    $ bundle exec rails g pulse_toolbox:install

Launch your application and visit <tt>/monitoring</tt>

## Extra configuration

You can add your own groups of sensors to page in initializer:
    
    group = PulseToolbox::Sensor::Manager.add_group(:min)
    PulseToolbox::Sensor::Manager.add_sensor(group, :user_age, {
        :sensor_type => 'timelined/min',
        :color => '#0000FF',
        :args => {
          :ttl => 10.days,
          :interval => 10.minutes,
          :raw_data_ttl => 10.hours,
          :reduce_delay => 2.minutes,
          :annotation => "User ages"
        }
      }
    })
    
Default layout can be easily exteneded in initializer by standart pulse-meter [DSL](https://github.com/savonarola/pulse-meter#full-example-with-dsl-explanation)
    
    PulseMeter::Sensor::Timelined::Counter.new(:custom_sensor,
      :ttl => 1.hour,
      :interval => 1.minute,
      :raw_data_ttl => 10.minutes,
      :reduce_delay => 2.minutes
    )

    PulseToolbox::Sensor::Manager.layout do |l|
      l.page "Custom" do |p|
        p.spline "Custom sensor" do |w|
          w.sensor :custom_sensor, :color => "#0000FF"

          w.timespan 60 * 60 * 3
          w.redraw_interval 10

          w.show_last_point true
          w.values_label "Time"
          w.width 10
        end
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

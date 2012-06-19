require "active_support"
require "active_support/all"
require "pulse-meter"

require "pulse_toolbox/sensor/initializer"

module PulseToolbox
  extend ActiveSupport::Autoload

  autoload :VERSION, 'pulse_toolbox/version'

  module Generators
    extend ActiveSupport::Autoload
    autoload :InstallGenerator
  end

  module Server
    extend ActiveSupport::Autoload
    autoload :Monitoring
  end

  module Sensor
    extend ActiveSupport::Autoload
    autoload :Manager
    module Mixins
      extend ActiveSupport::Autoload
      autoload :Iterators
    end
  end

  class << self
    @@pid = nil
    @@redis_config = {}

    def redis=(redis)
      PulseMeter.redis = redis
      @@pid = Process.pid
      @@redis_config = {
        host: redis.client.host,
        port: redis.client.port,
        db: redis.client.db
      }
    end

    def redis
      reconnect if pid_changed
      PulseMeter.redis
    end

    def reconnect
      PulseMeter.redis = Redis.new(
        host: @@redis_config[:host],
        port: @@redis_config[:port],
        db: @@redis_config[:db]
      )
    end

    def maybe_reconnect
      reconnect if pid_changed
    end

    def pid_changed
      @@pid && @@pid != Process.pid
    end
  end
end

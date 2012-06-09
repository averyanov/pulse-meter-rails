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

  def self.redis=(redis)
    PulseMeter.redis = redis
  end

  def self.redis
    PulseMeter.redis
  end
end

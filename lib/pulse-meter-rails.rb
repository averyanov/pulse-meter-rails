require "active_support"
require "active_support/all"
require "pulse-meter"

module PulseToolbox
  extend ActiveSupport::Autoload

  autoload :VERSION, 'pulse_toolbox/version'
  module Server
    extend ActiveSupport::Autoload
    autoload :Monitoring
  end

  def self.redis=(redis)
    PulseMeter.redis = redis
  end
end

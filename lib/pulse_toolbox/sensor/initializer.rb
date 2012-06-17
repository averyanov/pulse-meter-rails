require 'rails'

module PulseToolbox
  module Sensor
    # Registeres an initializer which creates sensors and subscribes to
    # process_action.action_controller notification
    class Initializer < ::Rails::Railtie
      initializer "register_request_sensors", :after => :load_config_initializers do
        if PulseToolbox.redis
          ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, start, finish, id, payload|
            total_time = (finish - start) * 1000
            PulseToolbox::Sensor::Manager.log_request(total_time, payload)
          end
        else
          Rails.logger.error("PulseToolbox.redis is not defined. Sensors cannot be created")
        end
      end
    end
  end
end

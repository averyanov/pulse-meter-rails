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
            view_time = payload[:view_runtime]
            db_time = payload[:db_runtime]
            PulseToolbox::Sensor::Manager.log_request(total_time, view_time, db_time)
          end
        else
          Rails.logger.error("PulseToolbox.redis is not defined. Sensors cannot be created")
        end
      end
    end
  end
end

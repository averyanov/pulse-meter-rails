module PulseToolbox
  module Sensor
    class Manager
      class_attribute :default_options
      self.default_options = {
        :ttl => 1.day,
        :interval => 1.minute,
        :raw_data_ttl => 1.hour,
        :reduce_delay => 2.minutes
      }.freeze

      class_attribute :sensors
      self.sensors = {}

      class << self
        def create_sensors
          create_sensor(:max, :max_db_time, "Max DB time")
          create_sensor(:max, :max_view_time, "Max View time")
          create_sensor(:max, :max_total_time, "Max Total time")
          create_sensor(:percentile, :p95_db_time, "95% percentile of DB time", {:p => 0.95})
          create_sensor(:percentile, :p95_view_time, "95% percentile of View time", {:p => 0.95})
          create_sensor(:percentile, :p95_total_time, "95% percentile of Total time", {:p => 0.95})
        end

        def create_sensor(type, name, annotation, extra_options = {})
          klass = "PulseMeter::Sensor::Timelined::#{type.to_s.classify}".constantize
          sensors[name] = klass.new(name, default_options.merge(extra_options).merge({:annotation => annotation}))
        end

        def log_request(total_time, view_time, db_time)
          [
            [:max_db_time, db_time],
            [:p95_db_time, db_time],
            [:max_view_time, view_time],
            [:p95_view_time, view_time],
            [:max_total_time, total_time],
            [:p95_total_time, total_time]
          ].each {|sensor, value = e| event(sensor, value)}
        end

        def event(sensor, value)
          sensors[sensor].event(value.to_i)
        end
      end
    end
  end
end

module PulseToolbox
  module Sensor
    class Manager
      class_attribute :default_options
      class_attribute :sensors_config
      class_attribute :sensors

      self.default_options = {
        :ttl => 1.day,
        :interval => 1.minute,
        :raw_data_ttl => 1.hour,
        :reduce_delay => 2.minutes
      }.freeze

      self.sensors_config = {
        :max_db_time => {
          :sensor_type => 'timelined/max',
          :color => '#0000FF',
          :args => {
            :annotation => "Max DB time"
          }.merge(self.default_options)
        },
        :max_view_time => {
          :sensor_type => 'timelined/max',
          :color => '#00FF00',
          :args => {
            :annotation => "Max View time"
          }.merge(self.default_options)
        },
        :max_total_time => {
          :sensor_type => 'timelined/max',
          :color => '#FF0000',
          :args => {
            :annotation => "Max total time"
          }.merge(self.default_options)
        },
        :p95_db_time => {
          :sensor_type => 'timelined/percentile',
          :color => '#0000FF',
          :args => {
            :annotation => "95% percentile of DB time",
            :p => 0.95
          }.merge(self.default_options)
        },
        :p95_view_time => {
          :sensor_type => 'timelined/percentile',
          :color => '#00FF00',
          :args => {
            :annotation => "95% percentile of View time",
            :p => 0.95
          }.merge(self.default_options)
        },
        :p95_total_time => {
          :sensor_type => 'timelined/percentile',
          :color => '#FF0000',
          :args => {
            :annotation => "95% percentile of Total time",
            :p => 0.95
          }.merge(self.default_options)
        }
      }

      def self.create_sensors
        self.sensors = PulseMeter::Sensor::Configuration.new(sensors_config)
      end

      def self.log_request(total_time, view_time, db_time)
        [
          [:max_db_time, db_time],
          [:p95_db_time, db_time],
          [:max_view_time, view_time],
          [:p95_view_time, view_time],
          [:max_total_time, total_time],
          [:p95_total_time, total_time]
        ].each {|name, value = e| event(name, value)}
      end

      def self.event(sensor, value)
        sensors.sensor(sensor).event(value.to_i)
      end

      def self.each_sensor_named_with(prefix = '')
        names = sensors_config.keys.select {|k| k =~ /^#{prefix}/}
        names.each do |name|
          sensor = sensors.sensor(name)
          yield(sensor)
        end
      end

      def self.color(sensor)
        sensors_config[sensor.name.to_sym][:color]
      end
    end
  end
end

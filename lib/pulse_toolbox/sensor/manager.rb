module PulseToolbox
  module Sensor
    class Manager
      class_attribute :default_options
      class_attribute :sensors_config
      class_attribute :configurator

      self.default_options = {
        :ttl => 1.day,
        :interval => 1.minute,
        :raw_data_ttl => 1.hour,
        :reduce_delay => 2.minutes
      }.freeze

      self.sensors_config = {
        :max => {
          :title => "Max times",
          :sensors => {
            :db_time => {
              :sensor_type => 'timelined/max',
              :color => '#0000FF',
              :args => {
                :annotation => "Max DB time"
              }
            },
            :view_time => {
              :sensor_type => 'timelined/max',
              :color => '#00FF00',
              :args => {
                :annotation => "Max View time"
              }
            },
            :total_time => {
              :sensor_type => 'timelined/max',
              :color => '#FF0000',
              :args => {
                :annotation => "Max total time"
              }
            }
          }
        },
        :p95 => {
          :title => "95% percentile times",
          :sensors => {
            :db_time => {
              :sensor_type => 'timelined/percentile',
              :color => '#0000FF',
              :args => {
                :annotation => "95% percentile of DB time",
                :p => 0.95
              }
            },
            :view_time => {
              :sensor_type => 'timelined/percentile',
              :color => '#00FF00',
              :args => {
                :annotation => "95% percentile of View time",
                :p => 0.95
              }
            },
            :total_time => {
              :sensor_type => 'timelined/percentile',
              :color => '#FF0000',
              :args => {
                :annotation => "95% percentile of Total time",
                :p => 0.95
              }
            }
          }
        }
      }

      def self.create_sensors
        self.configurator = PulseMeter::Sensor::Configuration.new(cfg)
      end

      class << self
        def log_request(total_time, view_time, db_time)
          [
            [:max_db_time, db_time],
            [:p95_db_time, db_time],
            [:max_view_time, view_time],
            [:p95_view_time, view_time],
            [:max_total_time, total_time],
            [:p95_total_time, total_time]
          ].each {|name, value = e| event(name, value)}
        end

        def event(sensor, value)
          configurator.sensor(sensor).event(value.to_i)
        end

        def cfg
          cfg = {}
          each_group do |group|
            sensors_config[group][:sensors].each_pair do |key, params|
              name = name_in_group(group, key)
              full_args = default_options.merge(params[:args])
              params[:args] = default_options.merge(params[:args])
              cfg[name] = params
            end
          end
          cfg
        end

        def each_sensor_in_group(group)
          sensors_config[group][:sensors].each_key do |name|
            sensor = configurator.sensor(name_in_group(group, name))
            yield(sensor)
          end
        end

        def each_group
          sensors_config.each_key do |group|
            yield(group)
          end
        end

        def each_group_with_title
          sensors_config.each_key do |group|
            yield(group, sensors_config[group][:title] || group)
          end
        end

        def each_sensor
          each_group do |group|
            each_sensor_in_group(group) do |sensor|
              yield(sensor)
            end
          end
        end

        def sensors
          list = []
          each_sensor {|s| list << s}
          list
        end
            
        def name_in_group(group, sensor_name)
          "#{group}_#{sensor_name}".to_sym
        end

        def color(sensor)
          return '#0000FF'
        end
      end
    end
  end
end

module PulseMeter
  module Sensor
    class Base
      attr_accessor :color
    end
  end
end

require 'pulse-meter/visualizer'

module PulseToolbox
  module Sensor
    class Manager
      extend PulseToolbox::Sensor::Mixins::Iterators
      # @!attribute [rw] default_options
      #   @return [Hash] default sensor options 
      class_attribute :default_options
      # @!attribute [rw] sensors_config
      #   @return [Hash] sensors config
      class_attribute :sensors_config
      # @!attribute [rw] configurator
      #   @return [PulseMeter::Sensor::Configuration] configurator instance
      class_attribute :configurator
      # @!attribute [rw] monitoring_layout
      #   @return [PulseMeter::Visualize::DSL::Layout] layout for monitoring page
      class_attribute :monitoring_layout

      self.monitoring_layout = PulseMeter::Visualize::DSL::Layout.new

      self.default_options = {
        ttl: 7.days,
        interval: 1.minute,
        raw_data_ttl: 1.hour,
        reduce_delay: 2.minutes
      }.freeze

      self.sensors_config = {
        max: {
          title: "Max times",
          values: "Time, ms",
          sensors: {
            db_time: {
              sensor_type: 'timelined/max',
              color: '#0000FF',
              args: {
                annotation: "DB"
              }
            },
            view_time: {
              sensor_type: 'timelined/max',
              color: '#00FF00',
              args: {
                annotation: "View"
              }
            },
            total_time: {
              sensor_type: 'timelined/max',
              color: '#FF0000',
              args: {
                annotation: "Total"
              }
            }
          }
        },
        p95: {
          title: "95% percentile times",
          values: "Time, ms",
          sensors: {
            db_time: {
              sensor_type: 'timelined/percentile',
              color: '#0000FF',
              args: {
                annotation: "DB",
                p: 0.95
              }
            },
            view_time: {
              sensor_type: 'timelined/percentile',
              color: '#00FF00',
              args: {
                annotation: "View",
                p: 0.95
              }
            },
            total_time: {
              sensor_type: 'timelined/percentile',
              color: '#FF0000',
              args: {
                annotation: "Total",
                p: 0.95
              }
            }
          }
        },
        p99: {
          title: "99% percentile times",
          values: "Time, ms",
          sensors: {
            db_time: {
              sensor_type: 'timelined/percentile',
              color: '#0000FF',
              args: {
                annotation: "DB",
                p: 0.99
              }
            },
            view_time: {
              sensor_type: 'timelined/percentile',
              color: '#00FF00',
              args: {
                annotation: "View",
                p: 0.99
              }
            },
            total_time: {
              sensor_type: 'timelined/percentile',
              color: '#FF0000',
              args: {
                annotation: "Total",
                p: 0.99
              }
            }
          }
        },
        status: {
          title: 'Request count',
          values: "Count",
          sensors: {
            total: {
              sensor_type: 'timelined/counter',
              color: '#FF0000',
              args: {
                annotation: "Total",
              }
            },
            count: {
              sensor_type: 'timelined/hashed_counter',
              color: '#008800',
              args: {
                annotation: "Status"
              }
            }
          }
        },
        action: {
          title: 'Request count by action',
          values: "Count",
          sensors: {
            count: {
              sensor_type: 'timelined/hashed_counter',
              color: '#008800',
              args: {
                annotation: "Action"
              }
            }
          }
        }
      }

      # Creates all sensors from sensors_config
      def self.create_sensors
        PulseToolbox.maybe_reconnect
        config = cfg
        self.configurator = PulseMeter::Sensor::Configuration.new(cfg)
        each_sensor do |s|
          s.color = config[s.name.to_sym][:color]
        end
      end

      class << self
        # Logs rails request timing to various sensors
        # @param total_time [Float] total request time
        # @param view_time [Float] view time of request
        # @param db_time [Float] db time of request
        def log_request(total_time, payload)
          view_time = payload[:view_runtime]
          db_time = payload[:db_runtime]

          lazy_configurator
          PulseToolbox.redis.multi do
            {
              max_db_time: db_time,
              max_view_time: view_time,
              max_total_time: total_time,

              p95_db_time: db_time,
              p95_view_time: view_time,
              p95_total_time: total_time,

              p99_db_time: db_time,
              p99_view_time: view_time,
              p99_total_time: total_time,

              status_count: {payload[:status].to_s => 1},
              status_total: 1,

              action_count: {"#{payload[:controller]}##{payload[:action]}" => 1}
            }.each_pair {|name, value| event(name, value)}
          end
        end
        
        # Sends value to sensor by name
        # @param sensor [Symbol] sensor name
        # @param value [Float] event value
        def event(sensor, value)
          lazy_configurator.sensor(sensor).event(value)
        end

        # Adds group to config
        # @param name [Symbol] group name
        # @param title [String] group title
        def add_group(name, title = nil)
          name = name.to_sym
          sensors_config[name] ||= {}
          sensors_config[name][:title] = title if title
          sensors_config[name][:sensors] ||= {}
          return name
        end
        
        # Adds sensor to group in config
        # @param group [Symbol] group name
        # @param name [Symbol] sensor name
        # @param options [Hash] sensor options
        def add_sensor(group, name, options)
          name = name.to_sym
          g = add_group(group)
          sensors_config[g][:sensors][name] = options
          return name_in_group(group, name)
        end

        # Returns monitoring page layout
        def layout
          yield(monitoring_layout)
          monitoring_layout
        end
        
      private

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

        def name_in_group(group, sensor_name)
          "#{group}_#{sensor_name}".to_sym
        end

        def get_sensor(group, name)
          lazy_configurator.sensor(name_in_group(group, name))
        end

        def lazy_configurator
          create_sensors unless configurator
          configurator
        end

      end
    end
  end
end

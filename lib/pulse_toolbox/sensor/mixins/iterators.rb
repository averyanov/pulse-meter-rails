module PulseToolbox
  module Sensor
    module Mixins
      module Iterators

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

        def each_sensor_in_group(group)
          sensors_config[group][:sensors].each_key do |name|
            sensor = get_sensor(group, name)
            yield(sensor)
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

      end
    end
  end
end

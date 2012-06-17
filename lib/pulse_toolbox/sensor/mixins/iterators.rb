module PulseToolbox
  module Sensor
    module Mixins
      module Iterators

        # Executes block for each group
        # @yieldparam group [Symbol] group name
        def each_group
          sensors_config.each_key do |group|
            yield(group)
          end
        end

        # Executes block for each group
        # @yieldparam group [Symbol] group name
        # @yieldparam title [String] group title
        # @yieldparam value_title [String] group sensor value meaning
        def each_group_with_title
          sensors_config.each_key do |group_name|
            group = sensors_config[group_name]
            yield(group_name, group[:title] || group_name,  group[:values] || '')
          end
        end

        # Executes block for each sensor in group
        # @param group [Symbol] group name
        # @yieldparam sensor [Symbol] sensor name
        def each_sensor_in_group(group)
          sensors_config[group][:sensors].each_key do |name|
            sensor = get_sensor(group, name)
            yield(sensor)
          end
        end

        # Executes block for each sensor
        # @yieldparam sensor [Symbol] sensor name
        def each_sensor
          each_group do |group|
            each_sensor_in_group(group) do |sensor|
              yield(sensor)
            end
          end
        end
        
        # Returns all sensors from config
        # @return [Array<Symbol>] sensors list
        def sensors
          list = []
          each_sensor {|s| list << s}
          list
        end

      end
    end
  end
end

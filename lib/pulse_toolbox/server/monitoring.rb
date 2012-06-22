require 'pulse-meter/visualizer'

module PulseToolbox::Server
  class Monitoring < PulseMeter::Visualize::App
    def initialize
      super(layout)
    end

    def layout
      PulseToolbox::Sensor::Manager.layout do |l|
        l.use_utc false

        l.page "Requests" do |p|
          PulseToolbox::Sensor::Manager.each_group_with_title do |group, title, values_label|
            p.line title do |w|
              PulseToolbox::Sensor::Manager.each_sensor_in_group(group) do |s|
                w.sensor s.name, :color => s.color
              end

              w.timespan 60 * 60 * 3
              w.redraw_interval 10

              w.show_last_point true
              w.values_label values_label
              w.width 5
            end
          end
        end
      end.to_layout
    end
  end
end

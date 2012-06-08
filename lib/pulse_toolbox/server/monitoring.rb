require 'pulse-meter/visualizer'

module PulseToolbox::Server
  class Monitoring < PulseMeter::Visualize::App
    def initialize
      super(layout)
    end

    def layout
      PulseMeter::Visualizer.draw do |l|
        l.title "Request processing times"
        l.use_utc false

        l.outlier_color '#FF0000'

        l.highchart_options({
          x_axis: {
            min_padding: 0,
            max_padding: 0
          }
        })

        l.page "Requests" do |p|
          
          PulseToolbox::Sensor::Manager.each_group_with_title do |group, title|
            p.spline title do |w|
              PulseToolbox::Sensor::Manager.each_sensor_in_group(group) do |s|
                w.sensor s.name, :color => PulseToolbox::Sensor::Manager.color(s)
              end

              w.timespan 60 * 60 * 3
              w.redraw_interval 10

              w.show_last_point true
              w.values_label "Time"
              w.width 10
            end
          end

          p.highchart_options({
            tooltip: {
              value_decimals: 0
            }
          })
        end
      end
    end
  end
end

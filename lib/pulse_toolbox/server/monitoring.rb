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

          p.spline "Max times" do |w|

            PulseToolbox::Sensor::Manager.each_sensor_named_with(:max) do |s|
              w.sensor s.name, :color => PulseToolbox::Sensor::Manager.color(s)
            end

            w.timespan 60 * 60 * 3
            w.redraw_interval 10

            w.show_last_point true
            w.values_label "Time"
            w.width 10
          end

          p.spline "95% percentile times" do |w|

            PulseToolbox::Sensor::Manager.each_sensor_named_with(:p95) do |s|
              w.sensor s.name, :color => PulseToolbox::Sensor::Manager.color(s)
            end

            w.timespan 60 * 60 * 3
            w.redraw_interval 10

            w.show_last_point true
            w.values_label "Time"
            w.width 10
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

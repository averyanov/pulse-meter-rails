require 'pulse-meter/visualizer'

module PulseToolbox::Server
  class Monitoring < PulseMeter::Visualize::App
    def initialize
      super(layout)
    end

    def layout
      PulseMeter::Visualizer.draw do |l|
        l.title "Metrics"
        l.use_utc false

        l.outlier_color '#FF0000'

        l.highchart_options({
          x_axis: {
            min_padding: 0,
            max_padding: 0
          }
        })

        l.page "Foo" do |p|
        end
      end
    end
  end
end

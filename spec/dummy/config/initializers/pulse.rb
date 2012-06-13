PulseToolbox.redis = Redis.new

PulseMeter::Sensor::Timelined::Counter.new(:custom_sensor,
  :ttl => 1.hour,
  :interval => 1.minute,
  :raw_data_ttl => 10.minutes,
  :reduce_delay => 2.minutes
)

PulseToolbox::Sensor::Manager.layout do |l|
  l.page "Custom" do |p|
    p.spline "Custom sensor" do |w|
      w.sensor :custom_sensor, :color => "#0000FF"

      w.timespan 60 * 60 * 3
      w.redraw_interval 10

      w.show_last_point true
      w.values_label "Time"
      w.width 10
    end
  end
end

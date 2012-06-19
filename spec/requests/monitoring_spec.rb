require 'spec_helper'

describe "/monitoring" do
  it "looks like correct dashboard" do
    visit "/monitoring"
    page.body.should match(/Pulse Meter/)
  end
end

describe "/monitoring/pages/:id/widgets" do
  let(:custom_tab) {1}
  let(:monitoring_tab) {2}

  before(:each) do
    PulseToolbox::Sensor::Manager.create_sensors
    PulseMeter::Sensor::Timelined::Counter.new(:custom_sensor,
      ttl: 1.hour,
      interval: 1.minute,
      raw_data_ttl: 10.minutes,
      reduce_delay: 2.minutes,
      annotation: "custom_sensor"
    )
  end

  def widgets_on_tab(tab_id)
    visit "/monitoring/pages/#{tab_id}/widgets"
    JSON.parse(page.source)
  end

  def sensor_names_on_tab(tab_id)
    found_annotations = []
    widgets_on_tab(tab_id).each do |w|
      w["series"].each do |s|
        found_annotations << s["name"]
      end
    end
    found_annotations
  end

  it "returns some groups of widgets" do
    groups = []
    PulseToolbox::Sensor::Manager.each_group {|g| groups << g}
    widgets_on_tab(monitoring_tab).count.should == groups.count
  end

  it "contains all sensors from PulseToolbox::Sensor::Manager config" do
    PulseToolbox::Sensor::Manager.log_request(3, {
      view_runtime: 2,
      db_runtime: 1,
      action: "foo",
      controller: 'BarController',
      status: 200,
    })

    annotations = PulseToolbox::Sensor::Manager.sensors.reject{|s|
      s.is_a?(PulseMeter::Sensor::Timelined::HashedCounter)
    }.map(&:annotation)

    annotations << "Status: 200"
    annotations << "Action: BarController#foo"

    sensor_names_on_tab(monitoring_tab).sort.should == annotations.sort
  end

  it "returns widgets of custom page created in initializer" do
    sensor_names_on_tab(custom_tab).should == ["custom_sensor"]
  end
end

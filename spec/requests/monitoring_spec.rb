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
  def visit_tab(tab_id)
    PulseToolbox::Sensor::Manager.create_sensors
    custom = PulseMeter::Sensor::Timelined::Counter.new(:custom_sensor,
      :ttl => 1.hour,
      :interval => 1.minute,
      :raw_data_ttl => 10.minutes,
      :reduce_delay => 2.minutes,
      :annotation => "custom_sensor"
    )
    visit "/monitoring/pages/#{tab_id}/widgets"
    @widgets = JSON.parse(page.source)
  end

  def all_annotations
    found_annotations = []
    @widgets.each do |w|
      w["series"].each do |s|
        found_annotations << s["name"]
      end
    end
    found_annotations
  end

  it "returns some groups of widgets" do
    visit_tab(monitoring_tab)
    groups = []
    PulseToolbox::Sensor::Manager.each_group {|g| groups << g}
    @widgets.count.should == groups.count
  end

  it "contains all sensors from PulseToolbox::Sensor::Manager config" do
    visit_tab(monitoring_tab)
    annotations = PulseToolbox::Sensor::Manager.sensors.map(&:annotation) 

    annotations.sort.should == all_annotations.sort
  end

  it "returns widgets of custom page created in initializer" do
    visit_tab(custom_tab)
    all_annotations.should == ["custom_sensor"]
  end
end

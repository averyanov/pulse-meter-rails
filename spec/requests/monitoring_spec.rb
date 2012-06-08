require 'spec_helper'

describe "/monitoring" do
  it "looks like correct dashboard" do
    visit "/monitoring"
    page.body.should match(/Request processing times/)
  end
end

describe "/monitoring/pages/:id/widgets" do
  before do
    PulseToolbox::Sensor::Manager.create_sensors
    visit '/monitoring/pages/1/widgets'
    @widgets = JSON.parse(page.source)
  end

  it "returns some groups of widgets" do
    groups = []
    PulseToolbox::Sensor::Manager.each_group {|g| groups << g}
    @widgets.count.should == groups.count
  end

  it "contains all sensors from PulseToolbox::Sensor::Manager config" do
    annotations = PulseToolbox::Sensor::Manager.sensors.map(&:annotation) 

    found_annotations = []
    @widgets.each do |w|
      w["series"].each do |s|
        found_annotations << s["name"]
      end
    end

    annotations.sort.should == found_annotations.sort
  end
end

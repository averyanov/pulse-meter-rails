require 'spec_helper'

describe PulseToolbox::Sensor::Manager do
  describe ".create_sensor" do
    let(:name) {"name"} 
    let(:annotation) {"annotation"}

    it "should create sensor with given type, name and annotation" do
      described_class.create_sensor(:min, name, annotation)
      sensor = PulseMeter::Sensor::Base.restore(name)
      sensor.name.should == name
      sensor.annotation.should == annotation
      sensor.should be_kind_of(PulseMeter::Sensor::Timelined::Min) 
    end

    it "should create sensor with default options" do
      described_class.create_sensor(:min, name, annotation)
      sensor = PulseMeter::Sensor::Base.restore(name)
      described_class.default_options.keys.each do |option|
        sensor.send(option).should == described_class.default_options[option]
      end
    end

    it "should take extra options to merge with default ones" do
      another_ttl = described_class.default_options[:ttl] + 1
      described_class.create_sensor(:min, name, annotation, {:ttl => another_ttl})
      sensor = PulseMeter::Sensor::Base.restore(name)
      sensor.ttl.should == another_ttl
    end
  end

  describe ".create_sensors" do
    it "should create some sensors" do
      lambda {described_class.create_sensors}.should change {PulseMeter::Sensor::Timeline.list_objects.count}
    end
  end

  describe ".event" do
    let(:name) {:cnt}
    let(:value) {123}
    it "should send given value to sensor" do
      described_class.create_sensor(:counter, name, "count")
      sensor = PulseMeter::Sensor::Base.restore(name)
      sensor.class.any_instance.should_receive(:event).with(value)
      described_class.event(name, value)
    end
  end

  describe ".log_request" do
    let(:total_time) {3}
    let(:db_time) {2}
    let(:view_time) {1}
    it "should be covered by RSPEC"
  end
end

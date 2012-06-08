require 'spec_helper'

describe PulseToolbox::Sensor::Manager do
  describe ".create_sensors" do
    it "creates some sensors" do
      lambda {described_class.create_sensors}.should change {PulseMeter::Sensor::Timeline.list_objects.count}
    end
  end

  describe ".event" do
    let(:value) {123}
    it "sends given value to sensor" do
      described_class.create_sensors
      sensor = described_class.sensors[0]
      sensor.class.any_instance.should_receive(:event).with(value)
      described_class.event(sensor.name, value)
    end
  end

  #describe ".each_sensor_named_with" do
  #  before do
  #    @sensors = []
  #    described_class.create_sensors
  #    described_class.each_sensor_named_with('max') {|s| @sensors << s}
  #  end
  #
  #  it "finds sensors" do
  #    @sensors.should_not be_empty
  #  end
#
#    it "passes Timelined sensor instance to block" do
#      @sensors.each {|s| s.should be_kind_of(PulseMeter::Sensor::Timeline)}
#    end
#
#    it "filteres sensors by name" do
#      @sensors.each {|s| s.name.should match(/^max/)}
#    end
#  end

  describe ".color" do
    it "returns color of created sensor" do
      described_class.create_sensors
      described_class.each_sensor do |s|
        described_class.color(s).should match(/^#[0-9A-F]{6}$/i)
      end
    end
  end

  describe ".log_request" do
    it "sends event to all created sensors" do
      described_class.create_sensors
      described_class.each_sensor {|s| s.should_receive(:event)}
      described_class.log_request(3, 2, 1)
    end
  end
end

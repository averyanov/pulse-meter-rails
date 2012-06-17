require 'spec_helper'

describe PulseToolbox::Sensor::Manager do

  describe ".create_sensors" do
    it "creates some sensors" do
      lambda {described_class.create_sensors}.should change {PulseMeter::Sensor::Timeline.list_objects.count}
    end

    it "adds color property to sensor" do
      described_class.create_sensors
      described_class.each_sensor do |s|
        s.color.should match(/^#[0-9A-F]{6}$/i)
      end
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

  describe ".log_request" do
    it "sends event to all created sensors" do
      described_class.create_sensors
      described_class.each_sensor {|s| s.should_receive(:event)}
      described_class.log_request(3, {
        :view_runtime => 2,
        :db_runtime => 1,
        :action => "foo",
        :controller => 'BarController',
        :status => 200
      })
    end
  end

  describe ".add_group" do
    before do
      described_class.create_sensors
    end

    it "adds group to list of groups" do
      old_groups = groups
      described_class.add_group(:new_group)
      new_groups = groups
      (new_groups - old_groups).should == [:new_group]
    end

    it "assigns title to group" do
      old_titles = titles
      described_class.add_group(:new_group, "New Title")
      new_titles = titles
      (new_titles - old_titles).should == ["New Title"]
    end

    it "overrides existing titles" do
      described_class.each_group do |g|
        described_class.add_group(g, "Title")
      end
      described_class.each_group_with_title do |g, t|
        t.should == "Title"
      end
    end

    it "preserves existing sensors" do
      sensors_count = {}
      described_class.each_group do |g|
        sensors_count[g] = sensors(g).count
        described_class.add_group(g, "Title")
      end

      described_class.each_group do |g|
        sensors(g).count.should == sensors_count[g]
      end
    end

    it "returns canonical name of created group" do
      described_class.add_group("new").should == :new
      described_class.add_group(:new).should == :new
    end
  end

  describe ".add_sensor" do
    let(:name) {:new_sensor}
    let(:options) {
      {
        :sensor_type => 'timelined/max',
        :color => '#0000FF',
        :args => {
          :ttl => 10.days,
          :interval => 10.minutes,
          :raw_data_ttl => 10.hours,
          :reduce_delay => 20.minutes,
          :annotation => "Annotation"
        }
      }
    }

    it "creates group unless it exists" do
      lambda {
        described_class.add_sensor(:nonexistant, name, options)
        described_class.create_sensors
      }.should change{groups.count}.by(1)
    end

    it "adds sensors to specified group" do
      group = groups[0]
      lambda {
        described_class.add_sensor(group, name, options)
        described_class.create_sensors
      }.should change {sensors(group).count}.by(1)
    end

    it "returns sensor name in group" do
      full_name = described_class.add_sensor(:max, name, options)
      described_class.create_sensors
      full_name.should == "max_#{name}".to_sym
    end

    it "assigns sensor's attributes correctly" do
      full_name = described_class.add_sensor(:max, name, options)
      described_class.create_sensors
      sensor = described_class.configurator.sensor(full_name)
      options[:args].each_pair do |k, v|
        sensor.send(k).should == v
      end
    end
  end

  describe ".layout" do
    it "passes layout instance to block" do
      described_class.layout do |l|
        l.should be_instance_of(PulseMeter::Visualize::DSL::Layout)
      end
    end
  end
end

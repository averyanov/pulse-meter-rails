require 'spec_helper'

describe PulseToolbox::Sensor::Mixins::Iterators do
  class SensorsContainer
    extend PulseToolbox::Sensor::Mixins::Iterators
    class_attribute :sensors_config
    self.sensors_config = {
      :g1 => {
        :title => "G1",
        :sensors => {
          :s11 => "sensor11",
          :s12 => "sensor12"
        }
      },
      :g2 => {
        :title => "G2",
        :sensors => {
          :s21 => "sensor21",
          :s22 => "sensor22"
        }
      }
    }
    def self.get_sensor(group, name)
      sensors_config[group][:sensors][name]
    end
  end

  describe ".each_group" do
    it "iterates over groups" do
      groups = []
      SensorsContainer.each_group {|g| groups << g}
      [:g1, :g2].sort.should == groups.sort
    end
  end

  describe ".each_group_with_title" do
    it "iterates over groups and their titles" do
      data = []
      SensorsContainer.each_group_with_title {|g, t| data << [g, t]}
      [[:g1, "G1"], [:g2, "G2"]].sort.should == data.sort
    end
  end

  describe ".each_sensor_in_group" do
    it "iterates over each sensor in specified group" do
      sensors = []
      SensorsContainer.each_sensor_in_group(:g1) {|s| sensors << s}
      ["sensor11", "sensor12"].sort.should == sensors.sort
    end
  end

  describe ".each_sensor" do
    it "iterates over each sensor" do
      sensors = []
      SensorsContainer.each_sensor {|s| sensors << s}
      ["sensor11", "sensor12", "sensor21", "sensor22"].sort.should == sensors.sort
    end
  end

  describe ".sensors" do
    it "returns all sensor" do
      ["sensor11", "sensor12", "sensor21", "sensor22"].sort.should == SensorsContainer.sensors.sort
    end
  end
end

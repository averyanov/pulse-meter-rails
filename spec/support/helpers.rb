module Helpers
  def titles
    titles = []
    described_class.each_group_with_title {|g, t| titles << t}
    titles
  end

  def groups
    groups = []
    described_class.each_group {|g| groups << g}
    groups
  end

  def sensors(group)
    sensors = []
    described_class.each_sensor_in_group(group) {|s| sensors << s}
    sensors
  end
end

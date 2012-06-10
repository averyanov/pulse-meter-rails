module Helpers
  RAILS_APP_PATH = "tmp/rails_app"

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

  def when_i_have_rails_app
    FileUtils.mkdir_p("tmp")
    FileUtils.remove_dir(RAILS_APP_PATH)
    system("rails new " + RAILS_APP_PATH + " > /dev/null 2>&1").should be_true
    system("ln -s ../../../lib/generators " + RAILS_APP_PATH + "/lib/generators").should be_true
  end

  def and_run_generator(name)
    system("cd " + RAILS_APP_PATH + " && rails g #{name}  > /dev/null 2>&1").should be_true
  end

  def i_should_see_route(route)
    routes = File.open(RAILS_APP_PATH + "/config/routes.rb").read
    routes.should include(route)
  end

  def i_should_see_file(file)
    File.exists?(RAILS_APP_PATH + "/" + file).should be_true
  end
end

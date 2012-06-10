require 'spec_helper'

describe "install generator" do
  it "should add route and create an initializer" do
    when_i_have_rails_app
    and_run_generator("pulse_toolbox:install")
    i_should_see_route("mount PulseToolbox::Server::Monitoring, :at => '/monitoring'")
    i_should_see_file("config/initializers/pulse_toolbox.rb")
  end
end

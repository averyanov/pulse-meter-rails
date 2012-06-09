require 'rails/generators'

module PulseToolbox
  class InstallGenerator < ::Rails::Generators::Base
    def create_initalizer
      initializer("pulse_toolbox.rb") do
        data = ""
        data << "PulseToolbox.redis = Redis.new\n"
        data << "PulseToolbox::Server::Monitoring.use Rack::Auth::Basic do |username, password|\n"
        data << "  username == 'admin' && password == 'secret'\n"
        data << "end\n"
        data
      end
    end

    def add_route
      route "mount PulseToolbox::Server::Monitoring, :at => '/monitoring'"
    end
  end
end

Dummy::Application.routes.draw do
  mount PulseToolbox::Server::Monitoring, :at => "/monitoring"
end

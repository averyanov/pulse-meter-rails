ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'bundler/setup'
$:.unshift File.expand_path('../../lib/', __FILE__)

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"
require 'capybara/rails'

Bundler.require(:default, :test, :development)

SimpleCov.start

require 'rack/test'
require 'pulse-meter-rails'

RSpec.configure do |config|
  config.before(:each) do
    PulseToolbox.redis = Redis.new
    PulseToolbox.redis.flushdb
  end
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end


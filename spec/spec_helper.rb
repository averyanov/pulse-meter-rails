require 'rubygems'
require 'bundler/setup'
$:.unshift File.expand_path('../../lib/', __FILE__)

ROOT = File.expand_path('../..', __FILE__)

Bundler.require(:default, :test, :development)

SimpleCov.start

require 'rack/test'
require 'pulse-meter-rails'

RSpec.configure do |config|
  config.before(:each) { PulseToolbox.redis = MockRedis.new }
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end


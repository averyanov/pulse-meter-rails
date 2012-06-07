# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pulse_toolbox/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sergey Averyanov"]
  gem.email         = ["averyanov@gmail.com"]
  gem.description   = %q{Pulse meter toolbox}
  gem.summary       = %q{Contains rails-oriented sensors and mountable visualisation server}
  gem.homepage      = "https://github.com/averyanov/pulse-meter-rails"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pulse-meter-rails"
  gem.require_paths = ["lib"]
  gem.version       = PulseToolbox::VERSION

  gem.add_runtime_dependency('pulse-meter')
  gem.add_runtime_dependency('activesupport', '>= 3.0')
  gem.add_runtime_dependency('rails', '>= 3.0')

  gem.add_development_dependency('capybara')
  gem.add_development_dependency('rack-test')
  gem.add_development_dependency('rails')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('redcarpet')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rspec-rails')
  gem.add_development_dependency('simplecov')
  gem.add_development_dependency('yard')
end

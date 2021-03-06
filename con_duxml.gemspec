# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "con_duxml"
  spec.version       = "0.5.0"
  spec.summary       = "Construct Universal XML"
  spec.authors       = ["Peter Kong"]
  spec.email         = ["peter.kong@nxp.com"]
  spec.homepage      = "http://www.github.com/Ludocracy/con_duxml"
  spec.license       = "MIT"

  spec.required_ruby_version     = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.8.11'

  # Only the files that are hit by these wildcards will be included in the
  # packaged gem, the default should hit everything in most cases but this will
  # need to be added to if you have any custom directories
  spec.files         = Dir["lib/**/*.rb", "lib/tasks/**/*.rake"]
  spec.executables   = []
  spec.require_paths = ["lib"]

  # Add any gems that your plugin needs to run within a host application
  spec.add_runtime_dependency "duxml", "~> 0.8.9"
  spec.add_runtime_dependency "ruby-dita", "~> 0.4"

  # Add any gems that your plugin needs for its development environment only
end

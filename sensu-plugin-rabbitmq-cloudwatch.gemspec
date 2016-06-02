# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensu/plugin/rabbitmq/cloudwatch/version'

Gem::Specification.new do |spec|
  spec.name          = "sensu-plugin-rabbitmq-cloudwatch"
  spec.version       = Sensu::Plugin::Rabbitmq::Cloudwatch::VERSION
  spec.authors       = ["Marc Watts"]
  spec.email         = ["marcky.sharky@googlemail.com"]

  spec.summary       = %q{Sensu Plugin for RabbitMQ metrics Cloudwatch}
  spec.description   = %q{Send RabbitMQ metrics to Cloudwatch}
  spec.homepage      = "https://github.com/marckysharky/sensu-plugin-rabbitmq-cloudwatch"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk", "~> 2"
  spec.add_dependency "sensu-plugin", "~> 1"
  spec.add_dependency "carrot-top", "~> 0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end

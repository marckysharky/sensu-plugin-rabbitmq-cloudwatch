#!/usr/bin/env ruby
# encoding: UTF-8

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sensu-plugin/cli'
require 'carrot-top'
require 'aws-sdk'

require 'sensu/plugins/rabbitmq/cloudwatch/counts'
require 'sensu/plugins/rabbitmq/cloudwatch/queues'

class MetricsRabbitMQ < Sensu::Plugin::CLI

  option :host,
         description: 'RabbitMQ management API host',
         long: '--host HOST',
         default: 'localhost'

  option :port,
         description: 'RabbitMQ management API port',
         long: '--port PORT',
         proc: proc(&:to_i),
         default: 15_672

  option :user,
         description: 'RabbitMQ management API user',
         long: '--user USER',
         default: 'guest'

  option :password,
         description: 'RabbitMQ management API password',
         long: '--password PASSWORD',
         default: 'guest'

  option :ssl,
         description: 'Enable SSL for connection to the API',
         long: '--ssl',
         boolean: true,
         default: false

  option :region,
         description: 'AWS Region',
         long: '--region REGION',
         default: 'us-east-1'

  option :namespace,
         description: 'Namespace',
         long: '--namespace NAMESPACE',
         proc: proc(&:strip),
         default: 'RabbitMQ'

  option :dimensions,
         description: 'Dimensions key:value,key:value',
         long: '--dimensions DIMENSIONS',
         proc: proc(&:strip),
         default: ''

  def run
    STDOUT.sync = true

    metrics = []
    metrics.push(*counts)
    metrics.push(*queues)
    metrics.each do |m|
      m[:dimensions] ||= []
      m[:dimensions] = Array(m[:dimensions]) + dimensions
    end

    metrics.each_slice(20) do |m|
      cloudwatch.put_metric_data(namespace: config[:namespace], metric_data: m)
    end

    ok('ok')
  rescue => e
    STDOUT.puts e.message
    STDOUT.puts e.backtrace
    warning(e.message)
  end

  def counts
    Sensu::Plugins::Rabbitmq::Cloudwatch::Counts.call(rabbitmq: rabbitmq)
  end

  def queues
    Sensu::Plugins::Rabbitmq::Cloudwatch::Queues.call(rabbitmq: rabbitmq)
  end

  def dimensions
    @dimenstions ||= (config[:dimensions] || '').split(',')
                                                .map { |v| v.split(':') }
                                                .map { |name, value| { name: name, value: value } }
  end

  def cloudwatch
    @cloudwatch = Aws::CloudWatch::Client.new(region: config[:region])
  end

  def rabbitmq
    @rabbitmq ||= CarrotTop.new(
      host:     config[:host],
      port:     config[:port],
      user:     config[:user],
      password: config[:password],
      ssl:      config[:ssl]
    )
  end
end

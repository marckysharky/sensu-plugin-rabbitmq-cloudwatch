module Sensu
  module Plugins
    module Rabbitmq
      module Cloudwatch
        class Counts
          def self.call(rabbitmq: nil)
            return unless rabbitmq

            [
              {
                metric_name: 'Connections',
                value: rabbitmq.connections.size,
                unit: 'Count'
              },
              {
                metric_name: 'Channels',
                value: rabbitmq.channels.size,
                unit: 'Count'
              },
              {
                metric_name: 'Exchanges',
                value: rabbitmq.exchanges.size,
                unit: 'Count'
              },
              {
                metric_name: 'Queues',
                value: rabbitmq.queues.size,
                unit: 'Count'
              },
              {
                metric_name: 'Users',
                value: rabbitmq.users.size,
                unit: 'Count'
              }
            ]
          end
        end
      end
    end
  end
end

module Sensu
  module Plugins
    module Rabbitmq
      module Cloudwatch
        class Queues

          def self.call(rabbitmq: nil)
            rabbitmq.queues.map { |queue| metrics_for(queue) }.flatten
          end

          def self.metrics_for(queue)
            dimensions = [{ name: 'queue', value: queue['name'] }]

            [
              {
                metric_name: 'QueueMemory',
                value: queue['memory'],
                unit: 'Bytes'
              },
              {
                metric_name: 'QueueMessages',
                value: queue['messages'],
                unit: 'Count'
              },
              {
                metric_name: 'QueueMessagesRate',
                value: queue['messages_details']['rate'],
                unit: 'Count/Second'
              },
              {
                metric_name: 'QueueMessagesReady',
                value: queue['messages_ready'],
                unit: 'Count'
              },
              {
                metric_name: 'QueueMessagesReadyRate',
                value: queue['messages_ready_details']['rate'],
                unit: 'Count/Second'
              },
              {
                metric_name: 'QueueMessagesUnacknowledged',
                value: queue['messages_unacknowledged'],
                unit: 'Count'
              },
              {
                metric_name: 'QueueMessagesUnacknowledgedRate',
                value: queue['messages_unacknowledged_details']['rate'],
                unit: 'Count/Second'
              },
              {
                metric_name: 'QueueConsumers',
                value: queue['consumers'],
                unit: 'Count'
              },

              {
                metric_name: 'QueueMessagesRam',
                value: queue['messages_ram'],
                unit: 'Bytes'
              },
              {
                metric_name: 'QueueMessagesReadyRam',
                value: queue['messages_ready_ram'],
                unit: 'Bytes'
              },
              {
                metric_name: 'QueueUnacknowledgedRam',
                value: queue['messages_unacknowledged_ram'],
                unit: 'Bytes'
              },
              {
                metric_name: 'QueueMessagesPersistent',
                value: queue['messages_persistent'],
                unit: 'Count'
              },
              {
                metric_name: 'QueueMessageBytes',
                value: queue['message_bytes'],
                unit: 'Bytes'
              },
              {
                metric_name: 'QueueMessageBytesReady',
                value: queue['message_bytes_ready'],
                unit: 'Bytes'
              },
              {
                metric_name: 'QueueMessageBytesUnacknowledged',
                value: queue['message_bytes_unacknowledged'],
                unit: 'Bytes'
              },
              {
                metric_name: 'QueueMessageBytesRam',
                value: queue['message_bytes_ram'],
                unit: 'Bytes'
              },
              {
                metric_name: 'QueueMessageBytesPersistent',
                value: queue['message_bytes_persistent'],
                unit: 'Bytes'
              },
              {
                metric_name: 'QueueDiskReads',
                value: queue['disk_reads'],
                unit: 'Count'
              },
              {
                metric_name: 'QueueDiskWrites',
                value: queue['disk_writes'],
                unit: 'Count'
              }
            ].map do |metric|
              metric[:dimensions] = dimensions
              metric
            end
          end
        end
      end
    end
  end
end

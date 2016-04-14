require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'rest_client'
require 'json'

module Sensu::Extension
  class OpenTSDB < Handler

    def post_init()
    end

    def definition
      {
        type: 'extension',
        name: 'opentsdb'
      }
    end

    def name
      definition[:name]
    end

    def description
      'Outputs metrics to OpenTSDB'
    end

    def run(event_data)
      event = JSON.parse(event_data)
      raise "no configuration for opentsdb" unless @settings.has_key?(:opentsdb)
      conf = @settings[:opentsdb]
      url = "http://#{conf['server']}:#{conf['port']}/api/put"

      # init event and check data
      body = []
      host = event['client']['name']
      domain = conf['domain'] || '.'

      event['check']['output'].split(/\n/).each do |line|
        key, value, time = line.split(/\s+/)
        metric = key.split(domain, 2)[1]
        data = { timestamp: time.to_i, metric: metric, value: value.to_f, tags: { host: host} }
        body << data
      end
      output = JSON.dump(body)
      RestClient.post(url, output)
      yield("", 0)
    end

    def stop
      true
    end
  end
end

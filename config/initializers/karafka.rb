# App class
class App < Karafka::App
  setup do |config|
    config.kafka.hosts = ENV['KAFKA_HOSTS'].split(',')

    config.name = 'talkbirdy-myna'
    config.redis = { url: case ENV['KARAFKA_ENV']
                          when /production/
                            ENV['REDIS_URL']
                          else
                            'redis://localhost:6379'
                          end }

    config.inline_mode = false
  end
end

App.boot!
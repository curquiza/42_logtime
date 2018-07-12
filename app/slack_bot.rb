require 'slack-ruby-client'
require_relative 'bot_executor'

LOGTIME_CMD = '!logtime'

def valid_command text
  text.split(' ').first == LOGTIME_CMD
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

realtime_client = Slack::RealTime::Client.new
web_client = Slack::Web::Client.new

realtime_client.on :hello do
  puts "Successfully connected - login: '#{realtime_client.self.name}' - team : '#{realtime_client.team.name}' - https://#{realtime_client.team.domain}.slack.com."
  puts '-----'
end

realtime_client.on :message do |data|
  if valid_command data.text
    bot = BotExecutor.new realtime_client, web_client, data
    bot.execute
  end
end
realtime_client.start!

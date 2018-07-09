require 'slack-ruby-client'
require_relative 'message_parser'
require_relative 'user_logtime'

def usage_message
  '!logtime [login]                           -> current year from the beginning of the year.
  or !logtime [login] [year]                  -> from the beginning of the year.
  or !logtime [login] [Q1/Q2/Q3/Q4]           -> current year.
  or !logtime [login] [Q1/Q2/Q3/Q4] [year]'
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

realtime_client = Slack::RealTime::Client.new

realtime_client.on :message do |data|
  p "message : #{data.text}"
  request = MessageParser.new(data.text)
  puts "login = #{request.login}"
  puts "quarter id = #{request.quarter}"
  puts "year = #{request.year}"
  rslt = UserLogtime.new(request.login, {year: request.year, quarter: request.quarter}).compute
  puts rslt
end
realtime_client.start!

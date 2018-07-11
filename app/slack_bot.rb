require 'slack-ruby-client'
require_relative 'message_parser'
require_relative 'user_logtime'

def usage_message
  '!logtime [login]                           -> current year from the beginning of the year.
  or !logtime [login] [year]                  -> from the beginning of the year.
  or !logtime [login] [Q1/Q2/Q3/Q4]           -> current year.
  or !logtime [login] [year] [Q1/Q2/Q3/Q4]'
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

# Slack::RealTime::Client.configure do |config|
#   config.start_method = :rtm_start
# end

# client = Slack::Web::Client.new
# client.auth_test
#
# realtime_client = Slack::RealTime::Client.new
#
# realtime_client.on :message do |data|
#   p "message : #{data.text}"
#   # request = MessageParser.new(data.text)
#   # puts "login = #{request.login}"
#   # puts "quarter id = #{request.quarter}"
#   # puts "year = #{request.year}"
#   # user_logtime = UserLogtime.new(request.login, {year: request.year, quarter: request.quarter})
#   # puts "range = #{ user_logtime.range }\n"
#   # rslt = user_logtime.compute
#   # puts "rslt = #{ rslt }\n-----"
#
#   client.realtime_client.chat_postMessage(channel: data.channel, text: 'Ciao les nazes', as_user: true)
#   # client.reactions_add name: 'poop', timestamp: data.ts, channel: data.channel
# end
# realtime_client.start!

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected - login: '#{client.self.name}' - team : '#{client.team.name}' - https://#{client.team.domain}.slack.com."
end

client.on :message do |data|
  case data.text
  when 'bot hi' then
    client.message channel: data.channel, text: "Hi <@#{data.user}>!"
  when /^bot/ then
    client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
  end
end
client.start!

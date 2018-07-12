require 'slack-ruby-client'
require_relative 'message_parser'
require_relative 'user_logtime'

def usage_message
  '!logtime [login]                           -> current year from the beginning of the year.
  or !logtime [login] [year]                  -> from the beginning of the year.
  or !logtime [login] [Q1/Q2/Q3/Q4]           -> current year.
  or !logtime [login] [year] [Q1/Q2/Q3/Q4]'
end

def valid_command text
  text.split(' ').first == '!logtime'
end

def range_begin range
  date_start = Time.parse range.split(',').first
  date_start.strftime("%m/%d/%Y")
end

def range_end range
  date_end = Time.parse range.split(',').last
  date_end.strftime("%m/%d/%Y")
end

def germaine_talk rslt, range
  if rslt == 0
    "Tu n'étais pas à l'école entre le #{ range_begin(range) } et le #{ range_end(range) } !! :angry:"
  else
    "J'ai pu te voir seulement #{ rslt } #{ rslt == 1 ? "heure" : "heures" } à l'école entre le #{ range_begin(range) } et le #{ range_end(range) }..."
  end
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected - login: '#{client.self.name}' - team : '#{client.team.name}' - https://#{client.team.domain}.slack.com."
end

client.on :message do |data|
  if valid_command data.text
    puts "message : #{data.text} - user : #{ data.user }"
    request = MessageParser.new(data.text)
    user_logtime = UserLogtime.new(request.login, {year: request.year, quarter: request.quarter})
    puts "range = #{ user_logtime.range }\n"
    rslt = user_logtime.compute
    puts "rslt = #{ rslt }\n-----"
    client.message channel: data.channel, text: germaine_talk(rslt.round, user_logtime.range)
  end

end
client.start!

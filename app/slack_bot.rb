require 'slack-ruby-client'
require_relative 'message_parser'
require_relative 'user_logtime'

LOGTIME_CMD = '!logtime'

def error_message
  '*Une ~erreur~ feature est survenue* :cute:

  usage :
  `!logtime [login]`
  `!logtime [login] [year]`
  `!logtime [login] [q1/q2/q3/q4]`
  `!logtime [login] [year] [q1/q2/q3/q4]`'
end

def get_user users_list, user_id
  user = users_list['members'].select { |list| list['id'] == user_id }.first['name']
end

def valid_command text
  text.split(' ').first == LOGTIME_CMD
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
    "Tu n'étais *pas* à l'école entre le #{ range_begin(range) } et le #{ range_end(range) } !! :angry:"
  else
    "J'ai pu te voir seulement *#{ rslt } #{ rslt == 1 ? "heure" : "heures" }* à l'école entre le #{ range_begin(range) } et le #{ range_end(range) }..."
  end
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

client = Slack::RealTime::Client.new
web_client = Slack::Web::Client.new
users_list = web_client.users_list

client.on :hello do
  puts "Successfully connected - login: '#{client.self.name}' - team : '#{client.team.name}' - https://#{client.team.domain}.slack.com."
  puts '-----'
end

client.on :message do |data|
  if valid_command data.text
    begin
      puts "message : #{data.text} - user : #{ get_user(users_list, data.user) }"
      request = MessageParser.new(data.text)
      user_logtime = UserLogtime.new(request.login, {year: request.year, quarter: request.quarter})
      puts "range = #{ user_logtime.range }\n"
      rslt = user_logtime.compute
      puts "rslt = #{ rslt }\n-----"
      client.message channel: data.channel, text: germaine_talk(rslt.round, user_logtime.range)
    rescue StandardError
      client.message channel: data.channel, text: error_message
      puts '------'
    end
  end
end
client.start!

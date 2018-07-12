require_relative 'message_parser'
require_relative 'user_logtime'

class BotExecutor

  attr_reader :realtime_client, :web_client, :data

  def initialize realtime_client, web_client, data
    @realtime_client = realtime_client
    @web_client      = web_client
    @data            = data
  end

  def execute
    begin
      puts "message : \"#{data.text}\" - user : #{ get_user_name(data.user) }"
      request = MessageParser.new(data.text)
      request.login ? get_hours_rslt(request) : put_usage
    rescue OAuth2::Error
      put_login_error
    rescue StandardError
      put_undefined_errors
    end
    puts '-----'
  end

  private

  def get_hours_rslt request
    user_logtime = UserLogtime.new(request.login, {year: request.year, quarter: request.quarter})
    puts "range : #{ user_logtime.range }\n"
    rslt = user_logtime.compute
    puts "rslt : #{ rslt }"
    realtime_client.message channel: data.channel, text: germaine_talk(rslt.round, user_logtime.range)
  end

  def put_usage
    realtime_client.message channel: data.channel, text: usage_message
    puts 'usage'
  end

  def put_login_error
    realtime_client.message channel: data.channel, text: login_error_message
    puts 'bad login'
  end

  def put_undefined_errors
    realtime_client.message channel: data.channel, text: undefined_error_message
    puts 'undefined error'
  end

  def get_user_name user_id
    users_list = web_client.users_list
    user = users_list['members'].select { |list| list['id'] == user_id }.first['name']
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

  def undefined_error_message
    "*Une ~erreur~ _action totalement maitrisée_ est survenue* :cute:"
  end

  def login_error_message
    "Ce login n'existe pas ! :face_with_monocle:"
  end

  def usage_message
    "> Pour discuter avec germaine :smirk: :\n" + "> `!logtime <login> [year] [q1/q2/q3/q4]`"
  end


end

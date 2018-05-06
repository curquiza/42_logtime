require_relative 'logtime_calculator'

class UserLogtime

  attr_reader :user, :range

  def initialize user, params = {}
    @user  = user
    @range = determine_range params
    puts "RANGE = #{ range }\n-----"
  end

  def compute
    LogtimeCalculator.total_logtime_hours user, range
  end

  private

  def determine_range params
    year = params[:year] || Time.now.year
    case params[:quarter]
    when 1
      "#{ year }-01-01,#{ year }-03-31"
    when 2
      "#{ year }-04-01,#{ year }-06-30"
    when 3
      "#{ year }-07-01,#{ year }-09-30"
    when 4
      "#{ year }-10-01,#{ year }-12-31"
    else
      "#{ year }-01-01,#{ year }-12-31"
    end
  end

end

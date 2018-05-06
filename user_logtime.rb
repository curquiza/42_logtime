require_relative 'logtime_calculator'

class UserLogtime

  attr_reader :user, :year, :range

  def initialize user, params = {}
    @user  = user
    @year  = params[:year] || Time.now.year
    @range = determine_range params
    puts "RANGE = #{ range }\n-----"
  end

  def compute
    LogtimeCalculator.total_logtime_hours user, range
  end

  private

  def determine_range params
    quarter_ranges["q#{ params[:quarter] }"] || quarter_ranges[:default]
  end

  def quarter_ranges
    @quarter_ranges ||= {
      q1:      "#{ year }-01-01,#{ year }-03-31",
      q2:      "#{ year }-04-01,#{ year }-06-30",
      q3:      "#{ year }-07-01,#{ year }-09-30",
      q4:      "#{ year }-10-01,#{ year }-12-31",
      default: "#{ year }-01-01,#{ year }-12-31"
    }
  end

end

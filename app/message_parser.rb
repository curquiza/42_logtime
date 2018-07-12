class MessageParser

  attr_reader :words, :login, :quarter, :year

  QUARTERS = %w(q1 q2 q3 q4 Q1 Q2 Q3 Q4)

  def initialize message
    @words = message.split(' ')
    if get_login
      @login = get_login
      @year = get_year
      @quarter = get_quarter_id
    else
      throw StandardError
    end
  end

  private

  def command
    words.first
  end

  def get_login
    words[1]
  end

  def get_year
    words[2] if words[2] && words[2].match(/^201\d$/)
  end

  def get_quarter_id
    get_quarter[1] if get_quarter
  end

  def get_quarter
    to_use = get_year ? words[3] : words[2]
    if QUARTERS.include? to_use
      to_use
    end
  end

end

class MessageParser

  attr_reader :words, :login, :quarter, :year

  QUARTERS = %w(q1 q2 q3 q4 Q1 Q2 Q3 Q4)

  def initialize message
    @words   = message.split(' ')
    @login   = get_login
    @year    = get_year
    @quarter = get_quarter_id
  end

  private

  def get_login
    words[1]
  end

  def get_year
    to_use = words[2] if words[2] && words[2].match(/^201\d$/)
    if to_use
      to_use
    elsif words[3] && words[3].match(/^201\d$/)
      words[3]
    end
  end

  def get_quarter_id
    get_quarter[1] if get_quarter
  end

  def get_quarter
    to_use = words[2] if QUARTERS.include? words[2]
    if to_use
      to_use
    elsif QUARTERS.include? words[3]
      words[3]
    end
  end

end

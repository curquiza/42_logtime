class MessageParser

  attr_reader :words, :login, :quarter, :year

  QUARTERS = %w(q1 q2 q3 q4 Q1 Q2 Q3 Q4)

  def initialize message
    @words = message.split(' ')
    if valid_command && get_login
      @login = get_login
      @quarter = get_quarter_id
      @year = get_year
    else
      puts 'throw exception'
    end
  end

  private

  def valid_command
    command == '!logtime'
  end

  def command
    words.first
  end

  def get_login
    words[1]
  end

  def get_quarter_id
    get_quarter[1] if get_quarter
  end

  def get_quarter
    if QUARTERS.include? words[2]
      words[2]
    end
  end

  def get_year
    to_use = get_quarter ? words[3] : words[2]
    to_use if to_use && to_use.match(/^201\d$/)
  end

end

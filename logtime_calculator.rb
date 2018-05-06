require_relative 'api_42_caller'
require_relative 'header_link'

class LogtimeCalculator

  class << self

    def total_logtime_hours user, range
      response = API42Caller.new.request_locations_for(user, range)
      total = logtime_hours_in(response[:content])
      puts "FIRST -> total = #{ total }"
      calc_through_pagination total, response
    end

    private

    def calc_through_pagination total, response
      unless total == 0
        while (response = HeaderLink.next response[:links])
          rslt = logtime_hours_in response[:content]
          puts "rslt = #{ rslt }"
          break if rslt == 0
          total += rslt
          puts "total = #{ total }"
          puts "----------"
          sleep(0.5)
        end
      end
      total
    end

    def logtime_hours_in content_hash
      content_hash.sum do |line|
        hours_btw_two_dates(line['end_at'], line['begin_at'])
      end
    end

    def hours_btw_two_dates str_1, str_2
      (str_to_time(str_1) - str_to_time(str_2)) / 3600
    end

    def str_to_time str
      Time.parse str
    end

  end
end

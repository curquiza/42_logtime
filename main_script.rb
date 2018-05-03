require_relative 'api_42_caller'
require_relative 'header_link'
require 'pry'

def total_logtime_hours
  response = API42Caller.new.request_locations_for('curquiza', '2017-01-01,2018-01-10')
  total = logtime_hours_in response[:content]
  while (response = HeaderLink.next response[:links])
    total += logtime_hours_in response[:content]
  end
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

# response = API42Caller.new.request_locations_for('curquiza', '2017-01-01,2018-04-10')
# puts response[:content]
# puts logtime_hours_in response[:content]
# puts "\n"
# response_next = HeaderLink.next response[:links]
# puts response_next[:content]

puts total_logtime_hours
require 'pry'
require_relative 'user_logtime'

# user_logtime = UserLogtime.new('curquiza', { year: 2018, quarter: 1 })
user_logtime = UserLogtime.new('curquiza', {year: 2017})
puts user_logtime.compute
# puts user_logtime.range

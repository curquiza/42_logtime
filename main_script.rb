require_relative 'api_42_caller'
require 'pry'

# puts API42Caller.request_locations_for('curquiza', '2017-01-01,2018-04-10')
puts API42Caller.new.request_locations_for('curquiza', '2017-01-01,2018-04-10')

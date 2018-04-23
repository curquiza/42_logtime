require_relative 'api_42_caller'
require_relative 'header_link'
require 'pry'

response = API42Caller.new.request_locations_for('curquiza', '2017-01-01,2018-04-10')
puts response
puts '\n'
response_next = HeaderLink.next response
puts response_next

require "oauth2"
require 'pry'

class APIParser

  def self.parse_link_header str
    links = Hash.new
    str.split(',').each do |part, index|
      section = part.split(';')
      url = section[0][/<(.*)>/,1]
      name = section[1][/rel="(.*)"/,1].to_sym
      links[name] = url
    end
    links
  end

end

UID    = ENV['UID_42']
SECRET = ENV['SECRET_42']

# Create the client with your credentials
client = OAuth2::Client.new(UID, SECRET, site: "https://api.intra.42.fr")
# Get an access token
token = client.client_credentials.get_token

params = {
  range: { begin_at: '2017-01-01,2018-04-10' },
  # page:  { number: 2 },
}

# response = token.get('/v2/locations/graph/on/begin_at/by/month?user_id=curquiza').parsed
response = token.get('/v2/users/curquiza/locations', params: params)
parsed_response = response.parsed
header_links = response.headers["Link"]
# puts parsed_response
# puts "\n"
puts "HEADER" + header_links
links_hash = APIParser.parse_link_header header_links
# puts links_hash
puts "NEXT" + links_hash[:last].to_s
puts "LAST" + links_hash[:next].to_s
puts "FIRST" + links_hash[:first].to_s
puts "PREVIOUS" + links_hash[:prev].to_s

response_2 = token.get(links_hash[:next])
# puts response_2.parsed
header_links = response_2.headers["Link"]
puts "HEADER" + header_links
links_hash = APIParser.parse_link_header header_links

require_relative 'oauth2_caller'

class HeaderLink < OAuth2Caller

  def self.next response
    links = links_hash response
    request links[:next]
  end

  private

  def self.links_hash response
    links = response.headers["Link"]
    links_parser links
  end

  def self.links_parser
    links_hsh = Hash.new
    str.split(',').each do |part, index|
      section = part.split(';')
      url = section[0][/<(.*)>/,1]
      name = section[1][/rel="(.*)"/,1].to_sym
      links_hsh[name] = url
    end
    links_hsh
  end

end

require_relative 'api_42_caller'

class HeaderLink

  def self.next response_links
    links = links_hash response_links
    API42Caller.new.get_request links[:next]
  end

  private

  def self.links_hash response_links
    links_hsh = Hash.new
    response_links.split(',').each do |part, index|
      section = part.split(';')
      url = section[0][/<(.*)>/,1]
      name = section[1][/rel="(.*)"/,1].to_sym
      links_hsh[name] = url
    end
    links_hsh
  end

end

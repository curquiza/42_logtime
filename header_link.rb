require_relative 'api_42_caller'

class HeaderLink

  def self.next response_links
    links = links_hash response_links
    if links[:next]
      API42Caller.new.get_request links[:next]
    end
  end

  private

  def self.links_hash response_links
    response_links.split(',').each_with_object({}) do |link, hsh|
      section = link.split(';')
      url = section[0][/<(.*)>/,1]
      name = section[1][/rel="(.*)"/,1].to_sym
      hsh[name] = url
    end
  end

end
